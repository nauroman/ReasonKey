# GPT-6 Sol Ctrl presets: local validation

Date: 2026-09-22. Base commit: a0d46b790dc04dc8fe7a672efd7dc12d6973dfe5,
with uncommitted Sol6 runtime, configuration and documentation changes.
Runtime version remains 1.0.11; this is a local build, not a published release.
Codex package: OpenAI.Codex 26.915.4065.0.

Runtime SHA-256:
`CF0795EB0B126F6896628E6749050082A8F75EDB332B688CAD6C8B7E561D188F`.

Source --validate, Build.ps1 (compiled checks), documentation validation and
git diff --check passed. Build.ps1 was run without -Clean for this local change.

Installed the local direct build. Backed up the previous direct presets.ini,
copied the active Store presets and changed only Preset5-8 Name/Model values.
The original Store configuration remains intact. Setup logged install-complete
and the direct runtime logged startup with PID 65304 and eight presets.

Starting with the Codex picker closed at GPT-6 Astra Medium, sent real hotkeys:

| Hotkey | Final Button verified by runtime UIA | Local log time |
|---|---|---|
| Ctrl+F16 | GPT-6 Sol Light | 11:17:19 |
| Ctrl+F17 | GPT-6 Sol Medium | 11:17:39 |
| Ctrl+F18 | GPT-6 Sol High | 11:18:05 |
| Ctrl+F19 | GPT-6 Sol Extra High | 11:18:18 |

Evidence: %LOCALAPPDATA%/ReasonKey/ReasonKey.log, paired modern-selected and
selected records after exact Button verification. Independent desktop snapshots
also observed Light, Medium and High. The UI tool subsequently rejected input
because it detected user interaction; open-picker cases were not completed. The runtime subsequently logged
GPT-6 Astra Medium at 11:19:08. Chat, Work, legacy picker,
Store delivery and restart-after-sign-in behavior were not tested in this task.
