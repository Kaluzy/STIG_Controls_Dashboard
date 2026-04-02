# STIG Pilot Control Center Blueprint

## What this app is

This app is an internal STIG hardening control center. It is not just a dashboard and it is not just a reporting screen.

It exists to do three jobs at the same time:

- show the current state of the selected Windows 11 hardening controls
- prove what changed on Device B across the `36% -> 45% -> 51%` scan progression
- turn failed controls into a shared execution backlog with owners, priority, notes, and evidence

## Why the UI is structured this way

The UI is intentionally split by decision intent, not by raw data type.

- `Command Center`
  - for quick understanding
  - answers: what wave is active, what is approved, what is blocked, what changed, and what is risky

- `Pilot Wave`
  - for Device B QA execution
  - answers: what is ready for pilot, what still needs validation, what blocks sign-off, and what team owns the next move

- `Operations Backlog`
  - for broader program work
  - blends the previous `InfoSec` and `Teams` concepts into one place
  - answers: what failed in the baseline, who owns it, how important it is, what should happen next, and what needs another team

- `Control Library`
  - for reading and comparing controls by category

- `Risk Matrix`
  - for sequencing and stakeholder discussion

## Operating model

This product should behave like a hardening wave system, not a giant static backlog.

Recommended wave structure:

- `Wave 1`
- `Wave 2`
- `Hold / Future`
- `Full backlog`

Recommended lifecycle model:

- `Candidate`
- `Prioritized`
- `Owner Assigned`
- `Ready for Test`
- `Implemented in Lab`
- `Smoke Tested`
- `QA Requested`
- `QA Passed`
- `RFC Ready`
- `Released`
- `Rolled Back`
- `Deferred`

Recommended validation states:

- `Implemented`
- `Scan-Proven`
- `Needs Validation`
- `Failed / Regression`
- `Blocked by Ownership`

These states should stay visually separate so the app never confuses lifecycle progress with validation proof.

This structure keeps the same dataset visible through different decision lenses without creating too many tabs or asking the user to memorize internal labels.

## Main features

- selected Windows 11 command-center controls
- Device B pilot tracking
- lifecycle stage per control
- validation status per selected control
- script mapping and evidence notes
- baseline failure backlog using `V-` IDs as primary and `WN11-` benchmark IDs as secondary
- owner assignment
- owner person and cross-team dependency
- decision log
- priority scoring
- priority assignment
- note capture
- JSON import and export
- CSV and Markdown export
- shared persistence through a small file-backed API
- ownership-first filtering
- release-aware wave progression
- evidence-backed detail panels

## Data sources

- `Harding_STIG/Device B Scan/.../Results/SCAP/XML/*.xml`
  - source of truth for actual Device B scan state

- `Harding_STIG/Win11_STIG_Master35.csv`
  - source for the final selected Windows 11 set and pilot shape

- local script evidence and analysis
  - used to explain why scores moved and which remediations are real vs unproven

- DISA / STIG benchmark identifiers
  - `V-` IDs are primary program identifiers
  - `WN11-` IDs remain attached for SCC and benchmark traceability

## End goal

The end goal is not a prettier chart.

The end goal is a durable internal hardening program tool that:

- makes pilot status obvious
- keeps evidence tied to claims
- lets multiple teams participate without losing context
- helps leadership understand progress without reading raw SCC outputs
- becomes the working system of record for STIG planning, validation, and rollout

The headline value statement is:

`One shared operating picture for STIG pilot planning, validation, ownership, and rollout.`

## Current architectural direction

- static-first HTML control center
- small Node server for shared state
- JSON-backed baseline data
- structured multi-file data model next
- evidence-first model
- gradual move toward parsed sources instead of embedded hand-maintained arrays
