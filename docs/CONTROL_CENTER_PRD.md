# STIG Pilot Control Center PRD

## Product statement

STIG Pilot Control Center is a shared operating system for hardening controls, testing, evidence, ownership, and release decisions.

It is not just a report viewer. It is the working layer between raw SCC evidence, remediation work, pilot validation, and leadership release decisions.

## Users

- End User Computing
- InfoSec
- Sysadmins
- QA
- Infrastructure
- Network
- Directors and leadership

## Core problem

The project currently has evidence, scripts, spreadsheets, and planning notes, but the work can drift between them. That creates four risks:

- controls look done before they are scan-proven
- ownership is unclear across teams
- remediation and rollback knowledge is scattered
- leadership cannot quickly see what is actually ready for release

## Product goal

The product must make it easy to:

1. identify the most important controls first
2. move each control through a clear lifecycle
3. tie remediation and rollback to evidence
4. document decisions and tests
5. hand work cleanly across teams

## Non-goals

- not a one-click remediation platform in v1
- not a public dashboard
- not a replacement for raw SCC artifacts
- not a generic cyber dashboard

## Control lifecycle

Every control should move through one clear lifecycle:

1. Candidate
2. Prioritized
3. Owner Assigned
4. Ready for Test
5. Implemented in Lab
6. Smoke Tested
7. QA Requested
8. QA Passed
9. RFC Ready
10. Released
11. Rolled Back
12. Deferred

This lifecycle must stay separate from validation state. A control can be implemented and still fail validation.

## Validation model

Use these validation states:

- Not Started
- Implemented
- Scan-Proven
- Partial
- Failed / Regression
- Blocked by Ownership

## Primary workflows

### Workflow 1: Pick the next controls

- review command center priorities
- compare security value against friction and cross-team dependency
- mark controls as prioritized
- assign wave and owner

### Workflow 2: Implement and test

- document remediation method
- record policy location and script used
- capture smoke-test checklist
- attach evidence links
- move to QA Requested when ready

### Workflow 3: Release decision

- review readiness by wave
- surface blockers, regressions, and owner gaps
- confirm rollback plan
- move to RFC Ready or Hold

### Workflow 4: Leadership reporting

- show active wave
- show readiness score
- show blockers by team
- show Device A vs Device B evidence summary
- export weekly summary

## Information architecture

- Command Center
  - executive and engineering summary
- Pilot Wave Workspace
  - current wave execution
- Operations Backlog
  - baseline and owner-driven work queue
- Controls Library
  - source-of-truth control records
- Evidence & Reports
  - scan proof and report deltas
- QA / Release Readiness
  - smoke tests, blockers, RFC posture
- Decisions & Changes
  - history, notes, and handoff log

## Required data per control

- control_id
- benchmark_id
- title
- product
- category
- tier
- wave
- lane
- lifecycle_stage
- validation_state
- owner_team
- owner_person
- cross_team_dependency
- security_value
- user_impact
- support_impact
- operational_risk
- active_threat_relevance
- why_selected
- implementation_method
- policy_location
- remediation_steps
- rollback_steps
- validation_steps
- smoke_test_checklist
- pre_scan_link
- post_scan_link
- evidence_links
- status
- qa_status
- release_status
- decision_log
- notes
- last_updated
- updated_by

## Prioritization model

Use scoring fields:

- security_value: 1-5
- user_friction: 1-5
- support_friction: 1-5
- cross_team_dependency: 1-5
- operational_risk: 1-5
- active_threat_relevance: yes/no
- release_readiness: yes/no

Derived buckets:

- Highest Value
- Safe Quick Wins
- Needs Review
- Too Risky Right Now

## Storage model

Use four layers:

1. raw evidence folder
2. structured JSON for app data
3. markdown for human-readable change history and summaries
4. Notion or SharePoint-style collaboration layer for approvals and weekly reporting

JSON is the portable format, not the only database.

## MVP

### Must have

- lifecycle stage on every control
- owner team and owner person
- priority score and bucket
- evidence links
- decision log
- CSV export
- Markdown export
- wave workspace
- release readiness

### Should have

- separate data files instead of one large state blob
- per-control status history
- Notion bridge or sync import/export

### Later

- SQLite or lightweight local DB
- automated SCC/XML and workbook ingestion
- script preview and rollback preview
- richer Device A vs Device B comparison

## Success criteria

- a director can tell what is release-ready in under five minutes
- an engineer can tell exactly what to implement and how to validate it
- a QA lead can see what still blocks sign-off
- a control cannot be marked done without evidence and an owner
