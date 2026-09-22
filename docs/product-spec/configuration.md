# Presets and configuration

Canonical owner of preset semantics, defaults and parsing. Storage and migration
belong to [installation](installation.md); application of a preset belongs to
[picker](picker.md). Read through the [product core](../product-spec.md).

## Rules

A keyboard preset selects a complete Codex model/effort combination and an
independent Chat effort. Chat uses 5.6 Sol. The legacy INI names remain compatible
with both picker generations:

ChatGPT Work follows the Codex Model/Effort contract. Ordinary Chat has a separate
catalog; never describe its Sol presets as Astra or silently substitute it for
an explicitly requested Astra selection. The tested 26.903 ordinary Chat catalog
does not expose Astra.

| Hotkey | Codex model | Codex effort | ChatEffort / current Chat | Older combined Chat Power |
|---|---|---|---|---|
| F16 | Astra | Light | Instant | Light |
| F17 | Astra | Medium | Medium | Medium |
| F18 | Astra | High | High | High |
| F19 | Astra | Extra High | Pro | Max |
| Ctrl+F16 | Sol6 | Light | Instant | Light |
| Ctrl+F17 | Sol6 | Medium | Medium | Medium |
| Ctrl+F18 | Sol6 | High | High | High |
| Ctrl+F19 | Sol6 | Extra High | Pro | Max |
| Ctrl+Shift+F16 | Luna6 | Light | Instant | Light |
| Ctrl+Shift+F17 | Luna6 | Medium | Medium | Medium |
| Ctrl+Shift+F18 | Luna6 | High | High | High |
| Ctrl+Shift+F19 | Luna6 | Extra High | Pro | Max |

- Model names: Luna (5.6), Luna6 (6 Luna), Terra, Sol (5.6), Sol6 (6 Sol) and Astra (6).
  Efforts: Light, Medium, High, Extra High, Max,
  Ultra; actual availability must be exposed by the target picker.
- Codex aliases: Low → Light; xhigh → Extra High. Names are trimmed and
  case-insensitive.
- Astra also accepts GPT-6 Astra, gpt-6-astra and 6 Astra. Its Codex label uses
  6 Astra rather than the 5.6 prefix; default presets and Chat mapping
  remain as shown above.
- Luna6 also accepts GPT-6 Luna, gpt-6-luna and 6 Luna; Model=Luna retains 5.6.
- Sol6 also accepts GPT-6 Sol, gpt-6-sol and 6 Sol.
  Existing Model=Sol retains GPT-5.6 Sol; Chat remains on its independent
  5.6 Sol mapping.
- ChatEffort accepts Instant, Medium, High, Pro. Extra High is not a supported
  ChatEffort configuration value even though a legacy UI exposed that option.
- Missing ChatEffort uses the legacy defaults above for sections 1–4. Sections
  5–12 in the shipped configuration specify ChatEffort explicitly; further
  sections must also specify it to work in Chat.
- Use AutoHotkey keyboard syntax, unique hotkeys and consecutive Preset sections.
  Reload after editing. No wheel-cycle feature; legacy CycleUp/CycleDown keys
  are ignored.
- Missing/unavailable choices fail explicitly; do not silently choose another
  model or effort.
- Keep the shipped [commented example](../../config/default-presets.ini), built-in
  defaults, README tables and Quick Start consistent with this owner.

## Current implementation

The current ordinary Chat composer exposes Instant, Medium, High and Pro on
its independent scale. Its stable `Select ChatGPT model` Button is verified
through descendants or persisted Power status; the selected model radio is
also verified. Older combined-label Chat pickers retain the Light/Max mapping.

Source inspection: 2026-09-13, working-tree runtime AppVersion 1.0.11; see the Astra diagnostic report for earlier live
UI and upgrade proof.

In [ReasonKey.ahk](../../src/ReasonKey.ahk), LoadPresets reads General/PresetCount
(legacy missing/invalid value → 4, clamped to 1–20; shipped INI specifies 12),
then Preset1 through
PresetN. Hotkey, normalized Model and normalized Effort must be nonempty or that
section is skipped. Missing Name defaults to the normalized model/effort label.

A missing configuration file or zero accepted sections loads the twelve
DefaultPresets.
An invalid ChatEffort normalizes to empty without discarding an otherwise valid
Codex preset; applying it in Chat fails. RegisterConfiguredHotkeys separately
logs invalid AutoHotkey expressions as invalid-hotkey; that registration failure
does **not** rerun the default-preset fallback.

Evidence entry points: LoadPresets, DefaultPresets, NormalizeModelName,
NormalizeEffortName, NormalizeChatEffortName, GetDefaultChatEffortForPreset,
GetModelLabel and
the built-in --validate path. Real registration/selection still requires the
[regression matrix](../DEVELOPMENT.md).
