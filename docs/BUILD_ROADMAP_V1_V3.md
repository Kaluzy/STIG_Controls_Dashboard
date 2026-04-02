# Build Roadmap V1 to V3

## North star

Build a shared operating system for hardening controls, testing, evidence, ownership, and release decisions.

## V1

### Goal

Turn the current dashboard into a true control lifecycle manager without changing the static-first operating model.

### Deliver

- lifecycle stage on each control
- owner team and owner person fields
- priority scoring and bucket
- decision log per control
- CSV export
- Markdown summary export
- wave data separated from control data
- evidence link section normalized across views

### Current app changes

- expand the current selected-control model into structured control records
- split state into multiple JSON files
- update `Operations Backlog` to show lifecycle stage and latest decision
- update `Pilot Wave` to show stage movement instead of simple proven/partial/failed only
- update `Release Readiness` to use real stage and blocker data

## V2

### Goal

Reduce manual maintenance and make the app evidence-driven by default.

### Deliver

- automated import from SCC XML and workbook sources
- controls library backed by parsed source data
- test records and status history
- Device A vs Device B comparison model
- product STIG backlog for Chrome, Edge, Firefox, Defender, Office, IE, Adobe
- Notion bridge for weekly updates and approvals

### Current app changes

- replace embedded arrays with generated JSON
- map each control to exact evidence files
- add source links and import timestamps
- add weekly report generation

## V3

### Goal

Make the platform team-ready for sustained multi-team operation.

### Deliver

- lightweight DB layer such as SQLite
- change history with `who changed what`
- richer approvals and release workflow
- RFC and ring deployment tracking
- optional role-based views
- richer export packs for leadership and engineering

### Current app changes

- replace file-backed shared state with structured persistence
- add audit history
- add release packet export

## MVP priority order

1. lifecycle stage
2. owner team and owner person
3. priority scoring
4. decisions / history
5. CSV and Markdown export
6. split JSON into structured files
7. parsed data imports
8. Notion bridge

## What to avoid

- do not turn remediation into the main story before evidence and governance are clear
- do not treat JSON as the only system of record
- do not confuse implemented controls with validated controls
- do not let workbook status hide scan exceptions
