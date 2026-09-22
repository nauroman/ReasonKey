# ReasonKey 1.0.12 release evidence

Date: 2026-09-22 (America/Vancouver). Source: release changes on top of
`a0d46b790dc04dc8fe7a672efd7dc12d6973dfe5`; final sources are identified by tag
`v1.0.12`. Desktop app: OpenAI.Codex 26.915.4065.0, English picker labels.

## Final artifacts and local checks

Clean direct build and clean Store MSIX build completed. Compiled runtime and
installer validation, cross-path singleton probe, uninstaller path guards,
native updater build/self-test, and unpacked MSIX structural checks passed.
The manifest-adjusted packaged executable also exited 0 for --validate.

| Artifact | SHA-256 |
|---|---|
| Direct runtime | `090e15d1b2d60bbfd3ff14b36308da22570019b707f420788387144e2a471371` |
| Setup | `a11c9a4f81d27b46da8f4fc69c00d7924f49b7440b4a021c3e37a616ce608124` |
| Store MSIX 1.0.12.0 x64 | `1453602b11f7c0252498901574542c1867398d7a6141e8660ae35575df530064` |
| Packaged runtime | `19c976159d04d551999eed4d3dfd0a715db44a7b1214ec2b46c8f1780a2aa26f` |
| Packaged updater | `49660e5fb9ed7b7f76c1a7442661f6a54f18261ef4214868036411540fc539b9` |

Local reinstall preserved the active presets.ini SHA-256. The user's direct
configuration was separately backed up and intentionally changed to the twelve
requested presets. The existing Store configuration was retained; upgrades do
not overwrite custom settings. Only recognized ReasonKey runtimes were stopped.

## Real-window results

Tests used the installed final direct 1.0.12 executable. Each result required
the final accessible Button label (Chat uses its Text descendants), backed by
modern-selected/modern-chat-selected and selected log records. Calls returning
success or elapsed delays alone were not accepted as evidence.

| Surface | Input | Expected and observed |
|---|---|---|
| Ordinary Chat | F16–F19, Ctrl+F16–F19, Ctrl+Shift+F16–F19 | All twelve: 5.6 Sol Instant, Medium, High, Pro (11:31–11:33) |
| ChatGPT Work | F16–F19 | GPT-6 Astra Light, Medium, High, Extra High |
| ChatGPT Work | Ctrl+F16–F19 | GPT-6 Sol Light, Medium, High, Extra High |
| ChatGPT Work | Ctrl+Shift+F16–F19 | GPT-6 Luna Light, Medium, High, Extra High (Work matrix completed 11:35) |
| Codex | F17–F19, then F16 from compact popup | GPT-6 Astra Medium, High, Extra High, Light (11:40–11:42) |
| Codex | Ctrl+F16–F19 | GPT-6 Sol Light, Medium, High, Extra High (11:40–11:41) |
| Codex | Ctrl+Shift+F16–F19 | GPT-6 Luna Light, Medium, High, Extra High (11:41) |
| Work compact picker already open | Ctrl+F17 | GPT-6 Sol Medium (11:36:13) |
| Codex compact picker already open | F16 | GPT-6 Astra Light (11:42:10) |
| Ordinary Chat model-radio view already open | F16 | 5.6 Sol Instant (11:31) |

The visible ordinary Chat catalog offered Latest, GPT-5.6 Sol and GPT-5.5;
GPT-6 Astra/Sol/Luna were available in Work/Codex. Chat selection remains
independent through ChatEffort. Diagnostic mode was returned to Codex and the
original GPT-6 Astra High restored at 11:42:27. No prompts were submitted.
Interrupted attempts during concurrent user input were excluded.

Local evidence: `%LOCALAPPDATA%/ReasonKey/ReasonKey.log`; independent native
accessibility snapshots in the task. The checked-in 1.0.12 Quick Start image
shows all twelve presets; Store canvas SHA-256 is
`c298eebe2abcce1798ab7fbfd3bcb9e55c0bb908379854d3fc088c00e35f0b02`.

## Unverified gates

WACK and signed-development-package installation were not run because this
session is not elevated and cannot install the development trust certificate.
Unpacked payload validation is not an installed-package test. Legacy app builds,
the Work/Codex already-open model-radio case, custom Astra Max/Ultra, destructive
uninstall, clean-profile installation, both-order direct/Store launch, and actual
public Store update/restart were not reverified for 1.0.12. Existing compatibility
paths were retained; earlier release evidence is not a new pass.

## Distribution

Partner Center identity was checked against the reserved product. Submission 8
(`1152921505701953722`) accepted the unsigned final MSIX as Validated. Listing
and submission publication state are recorded after the final submission below.
