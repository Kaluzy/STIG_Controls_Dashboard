# Device B Scan Delta

Comparison of the three Windows 11 SCC scan states for Device B:

- `2026-03-05_075106 - Pre - 36%`
- `2026-03-05_233855 - Post - 45 %`
- `2026-04-01_115133 - Post - 51%`

## Score progression

- Windows 11 STIG:
  - `36.76 -> 45.20 -> 51.20`
- Product scores:
  - Chrome: `2.27 -> 11.36 -> 11.36`
  - Edge: `3.64 -> 9.09 -> 9.09`
  - IE 11: `0.73 -> 0.73 -> 0.73`
  - Firefox: `3.03 -> 3.03 -> 3.03`
  - Defender AV: `23.88 -> 23.88 -> 23.88`
  - .NET Framework: `69.23 -> 69.23 -> 69.23`
  - Office 365: `7.87 -> 7.87 -> 7.87`

## Windows 11 result counts

- Pre 36:
  - `pass: 93`
  - `fail: 159`
  - `error: 1`
  - `notchecked: 12`
- Post 45:
  - `pass: 113`
  - `fail: 137`
  - `error: 0`
  - `notchecked: 12`
- Post 51:
  - `pass: 128`
  - `fail: 122`
  - `error: 0`
  - `notchecked: 12`

## Device B QA pilot definition

The current Device B QA pilot should be taken from the `Win11_STIG_Pilot` sheet inside `Harding_STIG/Win11_STIG_Master35.csv`, not from `master_stig_35.csv`.

The top `14` worksheet rows contain the header plus the active QA set.

That means the active high-risk Device B QA set is `13` control entries, stored on worksheet rows `2-14`, and those rows are marked `Risk If Not Implemented = High`.

Those pilot rows are:

- `V-253358` Disable WDigest
- `V-253285` Disable PowerShell 2.0
- `V-253367` Command line in process logs
- `V-253414` PowerShell script block logging
- `V-253354` IPv4 source routing off
- `V-253353` IPv6 source routing off
- `V-253370` Credential Guard
- `V-253371, V-253426` VBS and DMA protection
- `V-253306, V-253317` Audit logon and logoff
- `V-253319, V-253324, V-278926, V-278931` Audit object access and file system
- `V-253325, V-253329, V-278932, V-278933` Audit policy change and privilege use
- `V-253330, V-253336` Audit system events
- `V-253259, V-253257` BitLocker baseline

The first remediation wave already moved most of this pilot set from the `36.76` baseline to the `45.20` post state, and the second wave pushed additional audit and hardware controls into the `51.20` state.

## Controls improved from pre 36 to post 45

- `V-253259` BitLocker full disk encryption
- `V-253353` IPv6 source routing highest protection
- `V-253354` Prevent IP source routing
- `V-253358` WDigest disabled
- `V-253367` Include command line in process creation events
- `V-253385` Prevent app compatibility inventory collection
- `V-253390` Turn off Microsoft consumer experiences
- `V-253392` Limit enhanced diagnostic data
- `V-253393` Telemetry not Full
- `V-253399` Disable Windows Game Recording and Broadcasting
- `V-253402` Block saved RDP passwords
- `V-253403` Block local drive sharing over RDP
- `V-253405` Require secure RPC for RDP session host
- `V-253406` Require high encryption for RDP
- `V-253413` Disable automatic sign-in after restart
- `V-253414` Enable PowerShell script block logging
- `V-253437` Force audit policy subcategories
- `V-253460` Prevent DES and RC4 Kerberos encryption
- `V-268317` Disable Copilot in Windows

## Controls improved from post 45 to post 51

- `V-253300` Password history = 24
- `V-253301` Maximum password age = 60 days or less
- `V-253302` Minimum password age = 1 day
- `V-253306` Audit credential validation failures
- `V-253307` Audit credential validation successes
- `V-253316` Audit logon failures
- `V-253317` Audit logon successes
- `V-253319` Audit file share failures
- `V-253324` Audit removable storage successes
- `V-253325` Audit policy change successes
- `V-253329` Audit sensitive privilege use successes
- `V-253330` Audit IPsec driver failures
- `V-253335` Audit system integrity failures
- `V-253336` Audit system integrity successes
- `V-253426` Kernel DMA protection enabled
- `V-278932` Additional audit control improved in the second jump

## Pilot row observations against the three scans

- `V-253358`, `V-253367`, `V-253414`, `V-253353`, `V-253354`, and `V-253259` clearly improved in the first jump from `36.76` to `45.20`.
- `V-253306`, `V-253317`, `V-253319`, `V-253324`, `V-253325`, `V-253329`, `V-253330`, `V-253336`, `V-253426`, and `V-278932` improved in the second jump from `45.20` to `51.20`.
- `V-253370` was already passing before the first scan delta and stayed aligned with the pilot.
- `V-253285` is marked `Tested / Passed` in the pilot sheet, but the SCC evidence shows `fail -> notapplicable -> notapplicable`, so the tracker should display that as a verification mismatch rather than a simple pass.
- `V-253371` was already passing before the final jump, while `V-253426` is the hardware-control component that moved in the `45 -> 51` scan.

## Controls that changed but still need attention by post 51

- `V-253285` PowerShell 2.0 disabled
  - `fail -> notapplicable -> notapplicable`
- `V-253292` Bluetooth off when not in use
  - unresolved
- `V-253343` Audit Other Policy Change Events successes
  - unresolved
- `V-253369` Virtualization-based Security enabled with platform security level
  - `pass -> pass -> fail`
- `V-253432` Built-in Administrator account disabled
  - unresolved

## Mapping to current scripts

### Strong alignment

- `BATCH 1 PASSWORD POLICIES`
  - matches the post `45 -> 51` jump for password-age/history controls
- `BATCH 3 AUDIT LOGGING`
  - matches most of the post `45 -> 51` jump for audit controls
- `BATCH 4 TELEMETRY & CONSUMER FEATURES`
  - matches `V-253390`, `V-253392`, `V-253393`
- `BATCH 5 CONSUMER UX & RDP HARDENING`
  - matches `V-253390`, `V-253402`, `V-253405`, `V-253406`
- `BATCH 2 BITLOCKER & HARDWARE SECURITY`
  - matches `V-253259` and `V-253426`

### Partial or uncertain alignment

- `DeviceB-Product-Hardening.ps1`
  - Chrome and Edge improved in the product summaries
  - Firefox, Defender, .NET, Office, and IE scores did not move across the three captured summaries
  - this means either:
    - the settings did not map to the scanned findings
    - the remediation did not persist
    - the scan scope/version did not credit the specific changes
    - or the changes were not present when the later scans ran

## Master tracker intersection

Improved controls already present in `master_stig_35.csv`:

- `V-253353`
- `V-253354`
- `V-253358`
- `V-253367`
- `V-253399`
- `V-253413`
- `V-253414`
- `V-253437`
- `V-253460`
- `V-268317`
- `V-253392`
- `V-253393`

Controls in `master_stig_35.csv` not yet improved by post 51 include:

- `V-253285`
- `V-253466`
- `V-253350`
- `V-253374`
- `V-253376`
- `V-253395`
- `V-253401`
- `V-253407`
- `V-253417`
- `V-253419`
- `V-253444`
- `V-253469`
- `V-253289`
- `V-253357`
- `V-253359`
- `V-253360`
- `V-253362`
- `V-253383`
- `V-253432`
- `V-253449`
- `V-253451`
- `V-253471`

## Immediate implications for the tracker

- The dashboard should show:
  - baseline scan
  - first remediation scan
  - second remediation scan
  - per-control state transitions
- The default pilot view should load from the `Win11_STIG_Pilot` top `14` worksheet rows, which means `13` high-risk control entries plus the header row.
- The master tracker should gain fields for:
  - `pre36_result`
  - `post45_result`
  - `post51_result`
  - `changed_in_phase`
  - `remediation_script`
  - `pilot_candidate`
  - `notes_on_persistence`
- Product-specific STIG sections should be tracked separately from the core Windows 11 list.
