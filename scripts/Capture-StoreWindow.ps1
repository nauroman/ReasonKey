[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [int]$ProcessId,
    [string]$OutputPath = '.build\ReasonKey-QuickStart-window.png'
)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$destinationPath = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot $OutputPath))
$resolvedRepository = [System.IO.Path]::GetFullPath($repositoryRoot).TrimEnd('\') + '\'
if (-not $destinationPath.StartsWith(
    $resolvedRepository,
    [System.StringComparison]::OrdinalIgnoreCase
)) {
    throw "Refusing to write outside the repository: $destinationPath"
}

$process = Get-Process -Id $ProcessId -ErrorAction Stop
$process.WaitForInputIdle(5000) | Out-Null
$process.Refresh()
if ($process.MainWindowHandle -eq [IntPtr]::Zero) {
    throw "Process $ProcessId does not have a visible main window."
}

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -ReferencedAssemblies System.Drawing, System.Windows.Forms -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public static class ReasonKeyStoreScreenshotNative
{
    private sealed class CaptureBackdrop : Form
    {
        protected override bool ShowWithoutActivation { get { return true; } }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [DllImport("dwmapi.dll")]
    public static extern int DwmGetWindowAttribute(
        IntPtr hwnd,
        int attribute,
        out RECT value,
        int valueSize);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern int GetSystemMetrics(int index);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr SetThreadDpiAwarenessContext(IntPtr context);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool IsIconic(IntPtr hwnd);

    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetWindowPos(IntPtr hwnd, IntPtr insertAfter,
        int x, int y, int width, int height, uint flags);

    [DllImport("dwmapi.dll")]
    public static extern int DwmFlush();

    public static Bitmap Capture(IntPtr hwnd)
    {
        // Keep DWM bounds and screen capture in physical pixels on one
        // native thread, even when the PowerShell host is DPI-unaware.
        IntPtr previous = SetThreadDpiAwarenessContext(new IntPtr(-4));
        if (previous == IntPtr.Zero)
            throw new Win32Exception(Marshal.GetLastWin32Error());
        try
        {
            if (IsIconic(hwnd))
                throw new InvalidOperationException("Restore the window before capturing it.");
            if (GetForegroundWindow() != hwnd)
                throw new InvalidOperationException("Bring the target window to the foreground before capturing it.");

            RECT frame;
            int result = DwmGetWindowAttribute(hwnd, 9, out frame, Marshal.SizeOf(typeof(RECT)));
            if (result != 0)
                Marshal.ThrowExceptionForHR(result);

            int width = frame.Right - frame.Left;
            int height = frame.Bottom - frame.Top;
            int desktopLeft = GetSystemMetrics(76), desktopTop = GetSystemMetrics(77);
            if (width <= 0 || height <= 0 || frame.Left < desktopLeft || frame.Top < desktopTop ||
                frame.Right > desktopLeft + GetSystemMetrics(78) ||
                frame.Bottom > desktopTop + GetSystemMetrics(79))
                throw new InvalidOperationException("The complete window must fit on screen before capture.");

            // Copy the composed desktop pixels: PrintWindow can omit DWM's
            // non-client border and leave black strips, even with correct bounds.
            // Keep the foreground window unobscured and inspect all four edges.
            var bitmap = new Bitmap(width, height, PixelFormat.Format32bppRgb);
            try
            {
                // Stage a neutral background BEHIND the real window, so its
                // rounded corners cannot pick up another app's text or imagery.
                // Nothing in the captured window is painted over or modified.
                using (var backdrop = new CaptureBackdrop())
                {
                    backdrop.FormBorderStyle = FormBorderStyle.None;
                    backdrop.ShowInTaskbar = false;
                    backdrop.StartPosition = FormStartPosition.Manual;
                    backdrop.BackColor = Color.FromArgb(17, 24, 39);
                    backdrop.Bounds = new Rectangle(frame.Left - 32, frame.Top - 32,
                        width + 64, height + 64);
                    backdrop.Show();
                    if (!SetWindowPos(backdrop.Handle, hwnd, 0, 0, 0, 0, 0x13))
                        throw new Win32Exception(Marshal.GetLastWin32Error());
                    backdrop.Refresh();
                    Marshal.ThrowExceptionForHR(DwmFlush());
                    using (var graphics = Graphics.FromImage(bitmap))
                        graphics.CopyFromScreen(frame.Left, frame.Top, 0, 0,
                            new Size(width, height), CopyPixelOperation.SourceCopy);
                }
                if (GetForegroundWindow() != hwnd)
                    throw new InvalidOperationException("Foreground changed during capture; retry.");
                return bitmap;
            }
            catch { bitmap.Dispose(); throw; }
        }
        finally { SetThreadDpiAwarenessContext(previous); }
    }
}
'@

$bitmap = [ReasonKeyStoreScreenshotNative]::Capture($process.MainWindowHandle)
$width = $bitmap.Width
$height = $bitmap.Height
try {
    New-Item -ItemType Directory -Path (Split-Path -Parent $destinationPath) `
        -Force | Out-Null
    $bitmap.Save($destinationPath, [System.Drawing.Imaging.ImageFormat]::Png)
}
finally {
    $bitmap.Dispose()
}

$hash = (Get-FileHash -LiteralPath $destinationPath -Algorithm SHA256).Hash
Write-Host "Captured Store preview window: $destinationPath"
Write-Host "Dimensions: ${width}x${height}"
Write-Host "SHA256: $hash"

[pscustomobject]@{
    Path = $destinationPath
    Width = $width
    Height = $height
    Sha256 = $hash
}
