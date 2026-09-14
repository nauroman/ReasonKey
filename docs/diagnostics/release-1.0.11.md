# ReasonKey 1.0.11 release evidence

Prepared on 2026-09-13 (America/Vancouver) from the working tree based on
`main` for the Astra and Sol shortcut expansion. The release tag points to
`a7437dfb60de3bb25e14f93522376910c3f23a1e`. This report distinguishes
build checks, user-reported operation, and gates that remain unverified.

## Build and artifacts

- `scripts/Build.ps1 -Clean` passed its compiled runtime/installer validation,
  uninstaller path guards, and copied-path singleton probe.
- Direct runtime SHA-256:
  `391dd60494ad83f558a66817d9b50fae5d5bfd3c067c6ffef806eb66afb4bac6`.
- Setup SHA-256:
  `f19e18a192ade246edd0f2ff2c549ac00473f5735dc885b02a4c2917f133618c`.
- `scripts/Build-Msix.ps1 -Clean -SkipRuntimeBuild -Store -IdentityFile
  packaging\msix\StoreIdentity.json` passed package creation and structural
  validation. Its unsigned x64 Microsoft Store package uses version 1.0.11.0
  and the reserved `RotorlashLabs.ReasonKey` identity.
- Store MSIX SHA-256:
  `8bb87ba2de4e3adac7d6c1168d3f40b213f423c9ba02b643ddc13b777304278f`.
  The manifest-adjusted packaged runtime passed `--validate` with exit 0.
  Build metadata is in `dist/msix/ReasonKey_1.0.11.0_x64.msix.build.json`.
- `scripts/Test-Documentation.ps1` passed and `git diff --check` found no
  whitespace errors.

## Screenshot

The user supplied `Screenshot 2026-09-13 191231.png` and requested its use.
`packaging/store/assets/ReasonKey-QuickStart-window.png` preserves those
1041x993 pixels byte-for-byte (SHA-256
`25c3c1f8b545b49e0e6239f16875993e7cc6d675f8c97aa8f793172fa85f14a1`).
The Store listing uses the visually inspected 1600x1200 framed PNG at
`packaging/store/assets/StoreScreenshot-ReasonKey-QuickStart.png` (SHA-256
`98089007a498427d37da67c185d2e58a5506cb942f5a9633f0e859833d03a42b`).
The supplied window's title reads 1.0.10; the new package itself is 1.0.11.0.

## Runtime and external gates

The user reported that all eight shortcuts work after testing the installed
configuration. That is user acceptance, separate from an independently completed
real-window regression matrix for the final 1.0.11 artifacts. The complete
Codex/ChatGPT starting-state matrix, installer preservation/removal, clean-user
profile, public Store installation, and delivered Store update/restart remain
unverified for this release. Legacy picker compatibility was not retested.
This session was non-elevated, so local WACK and a trusted development-package
installation could not be run. Partner Center validation and certification are
separate from those local checks.

## Remote publication

- GitHub release [v1.0.11](https://github.com/nauroman/codex-model-hotkeys/releases/tag/v1.0.11)
  was published on 2026-09-14 02:26:29 UTC, with the setup executable and its
  SHA-256 file. GitHub reports the setup asset digest as
  `sha256:f19e18a192ade246edd0f2ff2c549ac00473f5735dc885b02a4c2917f133618c`,
  matching the local artifact. The release is neither a draft nor a prerelease.
- Both release-commit GitHub Actions runs passed: [main push](https://github.com/nauroman/codex-model-hotkeys/actions/runs/34799185427)
  and [tag push](https://github.com/nauroman/codex-model-hotkeys/actions/runs/34799211291).
  The public privacy-policy URL returned HTTP 200.
- Partner Center product `9NLDRHX8Z0B1`, Submission 7
  (`1152921505701882554`), accepted the final 1.0.11.0 x64 MSIX as
  **Validated**. The English listing was updated with the eight shortcuts and
  user-supplied screenshot, and its prior 1.0.10 screenshot was removed.
  Certification instructions were updated and saved successfully. The
  publishing option remains automatic after certification.
- Partner Center then reported **Update in certification** on September 13
  local time (its displayed last-modified date is September 14), with
  Submission complete and Pre-processing in progress. This establishes
  submission, not certification or public delivery of 1.0.11. The currently
  live Store presence still showed Submission 6 at that time.
