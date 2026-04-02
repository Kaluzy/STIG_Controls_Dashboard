# Script Validation

This document validates the current remediation scripts against the captured Device B SCC scans:

- `2026-03-05_075106 - Pre - 36%`
- `2026-03-05_233855 - Post - 45 %`
- `2026-04-01_115133 - Post - 51%`

## Executive read

- The Windows 11 remediation batches did move Device B from `36.76` to `51.20`.
- `BATCH 1`, `BATCH 3`, `BATCH 4`, and `BATCH 5` each contain controls that are clearly proven by SCC.
- `BATCH 2` is only partly proven:
  - BitLocker and DMA protection are supported by the scans.
  - Credential Guard and HVCI were already passing or mixed before the final jump.
- `DeviceB-Product-Hardening.ps1` is mixed:
  - Chrome and Edge worked.
  - Firefox, Defender, .NET, and Office did not produce scan-proven gains.
  - IE was not actually implemented in the script.

## Windows 11 batches

### `BATCH 1 PASSWORD POLICIES`

Proven by scan:

- `V-253300` password history
- `V-253301` maximum password age
- `V-253302` minimum password age

Weak or unproven:

- `V-253303` minimum password length is not proven by the captured SCC deltas.
- `V-253297` and `V-253299` are local account-policy changes and can be overwritten by domain policy.

Important flag:

- The script itself warns these settings can revert after `gpupdate` or reboot. That means this batch is not a durable enterprise implementation path by itself.

### `BATCH 2 BITLOCKER & HARDWARE SECURITY`

Proven by scan:

- `V-253259` BitLocker baseline
- `V-253426` Kernel DMA protection

Weak or mixed:

- `V-253370` Credential Guard was already passing before the change, so the script is not proven as the reason.
- `V-253371` HVCI/VBS was already passing, while the related benchmark control `WN11-CC-000070` later regressed by the April 1, 2026 scan.

Important flag:

- This batch mixes controls that are already compliant with controls that actually moved. It should be split in the tracker into `proven`, `already-pass`, and `regression-risk`.

### `BATCH 3 AUDIT LOGGING`

Proven by scan:

- `V-253306`, `V-253307`
- `V-253316`, `V-253317`
- `V-253319`, `V-253324`
- `V-253325`, `V-253329`
- `V-253330`, `V-253336`
- `V-278932`

Not proven or incorrect:

- The event log sizing section is not fully correct.
- SCC still shows:
  - `WN11-AU-000500` fail
  - `WN11-AU-000505` fail
  - `WN11-AU-000510` fail

Why:

- The script sets `Security`, `System`, and `Application` logs to `32768`.
- The Windows 11 STIG requires the `Security` event log to be `1024000 KB` or greater.

### `BATCH 4 TELEMETRY & CONSUMER FEATURES`

Proven by scan:

- `V-253392`
- `V-253393`
- `V-253390`

Partly mixed:

- `V-253425` is bundled into the batch, but the proof is not as clean as the telemetry controls.

### `BATCH 5 CONSUMER UX & RDP HARDENING`

Proven by scan:

- `V-253405`
- `V-253406`
- `V-253402`
- consumer UX settings contributing to `V-253390`

Mixed:

- The script bundles consumer, RDP, and drive-redirect settings together, which makes per-control attribution less clean inside the tracker.

## Product hardening script

### Chrome

Worked.

Rule-level evidence:

- `DTBC-0008` fail -> pass
- `DTBC-0011` fail -> pass
- `DTBC-0038` fail -> pass
- `DTBC-0057` fail -> pass

Interpretation:

- The Chrome section is aligned to what SCC is checking.

### Edge

Worked.

Rule-level evidence:

- `EDGE-00-000002` fail -> pass
- `EDGE-00-000043` fail -> pass
- `EDGE-00-000050` fail -> pass

Interpretation:

- The Edge policy path is aligned to what SCC is checking.

### Firefox

Did not work as captured.

Targeted rules still failing on April 1, 2026:

- `FFOX-00-000002` TLS 1.2+
- `FFOX-00-000008` password store disabled
- `FFOX-00-000014` disable telemetry
- `FFOX-00-000025` enhanced tracking protection

What likely went wrong:

- The script uses `policies.json`, which is a valid Firefox policy surface for some settings.
- But `FFOX-00-000025` specifically expects the `Preferences` policy with `browser.contentblocking.category = strict` and `Status = locked`.
- The script uses `TrackingProtection` instead, which does not match the benchmark expectation.
- The other Firefox settings also still fail, which means the effective policy was not present or not recognized by SCC at scan time.

Tracker decision:

- Mark Firefox remediation as `failed / redesign needed`.

### Defender

Did not work as captured.

Still failing:

- `WNDF-AV-000009`
- `WNDF-AV-000010`
- `WNDF-AV-000011`
- `WNDF-AV-000073`
- and many other Defender controls

Why:

- The script uses `Set-MpPreference`, which sets runtime preferences.
- SCC is checking policy-backed administrative-template settings such as:
  - `Block at First Sight`
  - `Join Microsoft MAPS`
  - `Send safe samples`
  - cloud blocking level

Tracker decision:

- Mark Defender remediation as `wrong implementation surface`.

### .NET

Incomplete.

Still failing:

- `APPNET0075`
- `APPNET0062`
- `APPNET0063`
- `APPNET0065`

Why:

- The script only sets `SchUseStrongCrypto`.
- The STIG also expects additional TLS support configuration such as `SystemDefaultTlsVersions`.
- The other .NET findings are separate controls and are not addressed by the script at all.

Tracker decision:

- Mark .NET as `partial / incomplete`.

### Office 365

Did not work as captured.

Why:

- The script writes:
  - `HKLM\\SOFTWARE\\Policies\\Microsoft\\Office\\16.0\\Common\\Privacy`
  - `HKLM\\SOFTWARE\\Policies\\Microsoft\\Office\\16.0\\FileValidation`
- SCC is checking mostly:
  - app-specific `HKCU` file-validation paths for Word, Excel, and PowerPoint
  - machine IE security settings for Office programs

Interpretation:

- The current Office script is aimed at a much smaller and partly different policy surface than the benchmark.

Tracker decision:

- Mark Office remediation as `wrong paths / redesign needed`.

### Internet Explorer

Not implemented in the product script.

Interpretation:

- IE scan results staying flat is expected because there is no IE hardening section in `DeviceB-Product-Hardening.ps1`.

## Current flags

- `V-253369` VBS platform security regressed by the April 1, 2026 scan and must be reviewed before calling hardware hardening stable.
- Password and lockout settings should not be treated as finalized until the domain-level source of truth is confirmed.
- Event log sizing is still wrong for the Security log.
- Firefox, Defender, .NET, and Office should not be counted as validated remediation.
