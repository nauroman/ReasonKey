# Quick Start screenshot capture correction

On 2026-09-22 the Store screenshot's upper-left edge had a wide black strip
below the title bar. PrintWindow was rendering the full window into a bitmap
sized to DWM's visible frame. Capturing the full window before a measured crop
removed the wide strip but still left unpainted non-client borders on this PC.

The corrected capture uses composed screen pixels, physical-pixel DWM bounds,
a scoped per-monitor DPI context and foreground/minimized/desktop-bound guards.
A temporary neutral backdrop behind the actual window prevents unrelated
desktop content appearing through its rounded corners. The saved image contains
the real window, with no painted repairs or arbitrary cropping.

## Verified artifacts

- Raw 1.0.12 window: 1051x1101, SHA-256
  `4A9812335C69759BA523FB2A8EF3CB1E3C3E029897FC2B3BD96AE0FDF24CAB6F`.
- Store canvas: 1600x1200, SHA-256
  `6738B7F38FEA0E469826D1BE060FCCD3A4AF75A6BDA669CEC9FE6CF7F7BB28E9`.
- Both images visually inspected: all four edges, rounded corners, title,
  twelve shortcuts and bottom buttons are present; the black strip is absent.
- Foreground rejection exercised: an inactive target was refused without
  overwriting the image. The ordinary installed runtime was restored, and
  installed presets.ini retained its hash.
- Documentation validation and diff whitespace checks passed. No runtime or
  installer source changed; this is not a fresh application release test.
- ReasonKey commit `15a1f77` published the corrected asset and capture script;
  the public GitHub PNG hash matches the local Store canvas.
  Its [Windows CI](https://github.com/nauroman/ReasonKey/actions/runs/35771871852)
  passed documentation, runtime/installer build and unsigned MSIX checks.
- Portfolio commit `b6ecaa9` updates only its screenshot and generated image
  manifest. Existing dirty work is excluded. Profile knowledge was reviewed;
  no factual changes were required. Three knowledge tests and targeted lint
  passed. The complete
  [portfolio CI](https://github.com/nauroman/nauroman/actions/runs/35771866364)
  passed. Amplify job 94 passed build, deployment and verification. The public
  PNG returned HTTP 200 with image/png and the exact Store canvas hash above.
  The live ReasonKey project page was visually inspected with the complete
  corrected window visible.

## Store upload

Submission 8 transitioned from certification to publishing while this task was
preparing the image. The cancellation attempt did not return it to edit mode;
Partner Center reported certification passed and **Update in publishing**.
After Submission 8 finished publishing, Submission 9
(`1152921505701953053`) was created. Its existing Desktop screenshot was replaced
with the corrected PNG, retaining the caption and a single screenshot. The
uploaded image was visually inspected in Partner Center before saving.

The saved overview marked Store listings **Updated** and the validated
`ReasonKey_1.0.12.0_x64.msix` package **Unchanged**. Submission 9 was submitted;
Partner Center confirmed **Update in certification**, with submission complete
and pre-processing in progress. It is configured to publish as soon as
certification passes. Upload and submission are verified; public Store
propagation of this replacement is not yet verified.
