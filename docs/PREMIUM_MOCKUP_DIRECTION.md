# Premium Mockup Direction

## Product design direction

This product should feel like a serious internal enterprise platform, not a cyber dashboard and not a generic admin console.

The right tone is calm, disciplined, and evidence-first.

It should feel like:

- a control room for security hardening decisions
- a release console for pilot movement
- a source of operational truth that directors trust and engineers can act from immediately

The product should communicate confidence through restraint:

- soft neutral surfaces
- precise typography
- subtle borders
- low-saturation status colors
- clear spacing
- dense but readable information blocks

The app should never look flashy, alarmist, or hacker-themed.

## Visual design language

### Overall look

Use a soft neutral enterprise palette:

- warm off-white or pale blue-gray canvas
- dark navy for structure and typography
- muted teal for positive forward motion
- muted amber for review-needed states
- muted oxblood for blockers and regressions

The surfaces should feel layered, but quietly:

- soft panel elevation
- thin borders
- rounded corners in the 10-14px range
- restrained shadows

### Typography

Use a more refined enterprise stack than basic default UI.

Recommended direction:

- headings: `IBM Plex Sans`, `Aptos`, or `Soehne` if licensed
- tables and dense labels: `Inter`, `Aptos`, or `Segoe UI`
- mono data: `IBM Plex Mono` or `Consolas`

Typography hierarchy:

- page titles: firm and compact
- secondary explanation text: muted and readable
- metadata labels: uppercase, small, letterspaced
- table/detail content: clear, not oversized

## Why this design works

### For leadership

Leadership does not want the raw finding first.

They want:

- what wave is active
- what is ready
- what is blocked
- what changed this week
- whether the pilot should move

So the strongest surface is the Command Center, not the backlog.

### For engineering

Engineering needs exactness:

- V-ID
- benchmark ID
- implementation method
- validation evidence
- rollback posture
- ownership

So the app needs rich details, but they should be revealed through drawers, inspectors, and focused workspaces rather than dumped all at once on the home screen.

## Screen-by-screen mockup concepts

## 1. Command Center / Home

### Purpose

This is the strongest and most polished screen.

It answers in under 30 seconds:

- what wave is active
- whether release is possible
- what the biggest blockers are
- how Device B compares with the target posture

### Layout

Top section:

- sticky global filter bar
- compact search
- active wave chip
- mode toggle: `Leadership` and `Engineering`

Hero band:

- left: pinned `Wave 1` status card
- center: `Ready / QA / Hold` counters
- right: `Release recommendation` card

Middle section:

- `Device A vs Device B` comparison block
- `This week’s changes` activity strip
- `Top blockers by owner` panel

Bottom section:

- `Ownership summary`
- `High-risk hot items`
- `Quick links to evidence and reports`

### Component hierarchy

- pinned wave card
- readiness score
- status counters
- hot-item cards
- owner summary bars
- small activity timeline
- recommendation panel

## 2. Pilot Wave Workspace

### Purpose

This is the execution workspace for the current wave.

### Layout

Top:

- wave title
- wave goal
- ring target
- QA status
- RFC status

Center:

- scoped control table with sticky headers
- columns:
  - V-ID
  - title
  - owner
  - stage
  - validation
  - implementation method
  - rollback
  - next action

Right side:

- detail inspector panel
- when a row is selected, show:
  - why selected
  - what changed
  - smoke test evidence
  - rollback note
  - linked proof

### Design note

This screen should feel like a workbench, not a report.

## 3. Controls Library

### Purpose

Master source of truth for all tracked controls.

### Layout

Top:

- global search
- sticky filter bar
- owner filters
- product filters
- wave filters
- status filters

Body:

- rich table with persistent columns and compact density

Right drawer:

- detail drawer for selected control
- includes:
  - why selected
  - implementation method
  - validation method
  - remediation note
  - rollback note
  - evidence links
  - ownership
  - risk and friction tags

## 4. Evidence & Reports

### Purpose

This is the proof layer.

### Layout

Top:

- device selector
- report selector
- date range chips

Body:

- report cards for Device A and Device B
- pre/post comparison stack
- linked HTML / XML artifacts
- scan delta summary cards
- validation notes and anomalies

### Key UX move

Do not bury raw evidence in tables. Put linked evidence cards first, then delta summaries below.

## 5. Risk & Ownership Matrix

### Purpose

This is a decision page, not an operations page.

### Layout

- two-dimensional matrix
- overlays for owner and recommendation
- side legend for risk and friction
- inspector on click

Axes:

- security value
- user friction
- IT support friction
- operational risk as a bubble weight or side tag

This screen should be highly legible and presentation-ready.

## 6. QA / Release Readiness

### Purpose

This is the release gate.

### Layout

Top:

- release score
- ring stage
- RFC readiness
- blocker count

Center:

- stage board:
  - Candidate
  - Peer Review
  - Initial EUC / InfoSec Testing
  - TAB Review
  - QA Requested
  - QA Passed
  - RFC Ready
  - Pilot Ring
  - Full Ring
  - Closed

Bottom:

- app validation state
- smoke test summary
- regressions
- blocker ownership

## Required UX patterns

### Global filter bar

Sticky, compact, and always visible.

It should include:

- quick search
- owner
- wave
- product
- stage
- validation
- risk

### Ownership chips

Use strong, consistent owner chips.

Recommended team names:

- `Endpoint Security Engineering`
- `Identity & Access Engineering`
- `Security Operations & Detection`
- `Infrastructure & Trust Services`
- `Network Security Engineering`
- `Quality Assurance`

### Detail drawer

Prefer a side inspector instead of loading users into separate pages for every control.

### Evidence link section

Every major view should provide an easy path to the proof.

## Empty, error, and loading states

### Empty

Use calm empty states:

- “No controls match the current filter set.”
- “No blockers are open for this wave.”

### Error

Use plain language:

- “Shared state could not be loaded. Using local state.”
- “Evidence file is unavailable.”

### Loading

Use skeleton rows and muted shimmer, not spinner-only emptiness.

## Interaction notes

- sticky filter bars on dense pages
- sticky table headers
- side drawers for detail
- subtle motion only on tab change, drawer open, and row hover
- no decorative animation

## Recommended MVP screen order

1. Command Center
2. Pilot Wave Workspace
3. Controls Library
4. QA / Release Readiness
5. Evidence & Reports
6. Risk & Ownership Matrix

## Optional future enhancements

- comments and decision log
- role-based executive mode
- auto-import from SCC XML and workbook sources
- remediation preview and rollback preview
- saved views by team
- weekly change digest generation
