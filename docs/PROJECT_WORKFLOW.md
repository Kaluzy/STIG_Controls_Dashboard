# Project Workflow

This is the single working roadmap for the STIG Pilot Control Center project.

## Goal

Build one shared control center that answers these questions clearly:

1. What controls are in scope?
2. What is the Device B Phase 1 QA pilot?
3. What changed between `36.76`, `45.20`, and `51.20`?
4. Which remediations are proven, weak, wrong, or still pending?
5. What is ready for the next release step?
6. Which team owns the blocker?

## Source order

Use sources in this order:

1. SCC XCCDF XML for actual scan truth
2. `microsoft-windows-11-security-technical-implementation-guide.csv` for STIG metadata
3. `Win11_STIG_Master35.csv` `Win11_STIG_Pilot` for Device B Phase 1 pilot scope
4. `STIG_Controls_Dashboard.html` as the working control model for the 35 selected Windows controls
5. official DISA STIG artifacts for upstream validation
6. STIG Viewer for quick lookup and linking

## Working structure

### Surface 1: Command Center

Purpose:

- show the active wave
- summarize readiness
- surface blockers and changes
- compare Device A vs Device B where evidence exists

### Surface 2: Pilot Wave

Purpose:

- isolate the Device B QA pilot controls
- show only the high-risk pilot set from `Win11_STIG_Pilot`
- support weekly review and pilot sign-off

### Surface 3: Operations Backlog

Purpose:

- turn baseline fails into an owner-driven shared queue
- support security, EUC, infrastructure, QA, and leadership from the same source of truth
- make ownership, deployment path, and evidence impossible to miss

### Surface 4: Script validation

Purpose:

- separate `script executed` from `SCC proved it`
- identify incomplete or wrong implementation paths
- stop weak evidence from polluting the pilot story

## Delivery phases

### Phase 1: Evidence-backed control center

Done or in progress:

- promote the existing command-center dashboard into the project entry point
- add Device B scan progression
- add pilot filtering
- add validation states
- move the app toward a decision-first navigation model

Still needed:

- parse the workbook and SCC XML automatically instead of embedding manual mappings
- expose product/application remediation validation in the UI, not only docs
- add source links per control
- add explicit wave and stage data instead of implied status only

### Phase 2: Data import normalization

Build:

- workbook parser for `Win11_STIG_Master35.csv`
- XCCDF parser for Windows and product STIG scans
- merged control model with:
  - `pre36`
  - `post45`
  - `post51`
  - `pilot`
  - `script`
  - `validation`
  - `recommendation`
  - `fix_text`

### Phase 3: Recommendation and remediation guidance

Add:

- per-control recommendation text
- remediation ownership
- rollback notes
- app-specific guidance for:
  - Chrome
  - Edge
  - Firefox
  - Defender
  - Office
  - IE
  - Adobe

### Phase 4: Operational workflow

Use the tracker weekly:

1. review new SCC evidence
2. confirm which controls changed
3. update validation state
4. move controls through release stages
5. move proven controls toward pilot sign-off
6. flag regressions and blockers

## What matters most right now

Focus first on these items:

- finalize the 13-control Device B Phase 1 QA pilot
- fix the event log sizing gap
- resolve the VBS regression
- stop counting Firefox, Defender, .NET, and Office as validated
- build import automation so the dashboard stops depending on manual edits

## Lifecycle model to implement next

Leadership wants smaller batches and explicit release governance. The next model to add in data and UI is:

1. `Candidate`
2. `Prioritized`
3. `Owner Assigned`
4. `Ready for Test`
5. `Implemented in Lab`
6. `Smoke Tested`
7. `QA Requested`
8. `QA Passed`
9. `RFC Ready`
10. `Released`
11. `Rolled Back`
12. `Deferred`

Validation must still remain separate:

- `Not Started`
- `Implemented`
- `Scan-Proven`
- `Partial`
- `Failed / Regression`
- `Blocked by Ownership`

## Things that do not make sense yet

- treating local password-policy remediation as enterprise-final
- treating runtime Defender preferences as equivalent to STIG policy compliance
- treating Office common privacy keys as if they cover the Office STIG
- assuming Firefox `TrackingProtection` satisfies the strict locked preference check
- claiming IE was remediated when it was not implemented in the product script
