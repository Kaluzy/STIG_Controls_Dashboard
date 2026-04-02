# STIG Pilot Control Center

One shared operating picture for STIG pilot planning, validation, ownership, and rollout.

## Purpose

This project is aligned to the Notion roadmap, the architecture guidance, and the local `Harding_STIG` evidence set:

- Move from research into controlled pilot implementation.
- Keep Device A as the full-hardening reference device.
- Keep Device B as the balanced pilot baseline.
- Use the 35-control command center as the working dashboard.
- Use Device B as the Phase 1 QA pilot reference.
- Emphasize evidence, validation, ownership, and rollback before broad rollout.
- treat the product as a hardening control center, not just a findings dashboard
- support wave-based execution and release readiness, not one giant backlog

## MVP scope

- Full 35-control Windows 11 dashboard
- Device B Phase 1 QA pilot filtering
- Validation states: `Proven`, `Partial`, `Failed`, `Pending`
- Scan progression for `36.76 -> 45.20 -> 51.20`
- Script validation notes in control detail
- Application validation summary for Chrome, Edge, Firefox, Defender, .NET, Office, and IE
- Operations backlog using `V-` IDs with `WN11-` benchmark references
- Shared note and priority persistence through a small file-backed API
- JSON export and import for state rotation or backup
- Clear purpose-based navigation: `Command Center`, `Pilot Wave`, `Operations Backlog`, `Control Library`, `Risk Matrix`
- Architecture aligned to leadership workflow: peer review, EUC + InfoSec testing, QA, RFC, pilot ring, repeat

## Structure

- `index.html`: main tracker built from the command-center dashboard
- `server.js`: lightweight local server for shared state and static hosting
- `data/baseline-data.js`: generated Windows 11 baseline failure data with `V-` and `WN11-` mappings
- `data/shared-infosec-state.json`: file-backed shared state for owner notes and priorities
- `docs/CONTROL_CENTER_PRD.md`: product requirements for turning the app into a control lifecycle system
- `docs/DATA_SCHEMA.md`: professional control, wave, test, owner, and decision record shapes
- `docs/BUILD_ROADMAP_V1_V3.md`: phased implementation roadmap from current app to team-ready platform
- `docs/DEPLOYMENT_PATHS.md`: GitHub Pages and Proxmox deployment strategy
- `docs/ROADMAP_ALIGNMENT.md`: implementation rules derived from Notion
- `docs/PROJECT_CHARTER.md`: scope and operating model
- `docs/SCRIPT_VALIDATION.md`: scan-backed script validation
- `docs/PROJECT_WORKFLOW.md`: single working roadmap and workflow
- `docs/APP_BLUEPRINT.md`: what the app is, why the UI is structured this way, and the end goal
- `docs/TOOL_PROMPT.md`: reusable product prompt for future expansion or rebuild
- `docs/Architecure_Advise.md`: architecture guidance that reframed the product as a control center
- `docs/PREMIUM_MOCKUP_DIRECTION.md`: premium enterprise UX direction and page-by-page mockup concepts

## Run

Preferred:

- `node server.js`
- open `http://localhost:3085`

Static published option:

- GitHub Pages via `.github/workflows/deploy-pages.yml`
- expected URL after Pages is enabled:
  - `https://kaluzy.github.io/STIG_Controls_Dashboard/`

Fallback:

- open [index.html](/c:/Users/kaluz/OneDrive/Documents/AI%20Playground/STIG-Pilot-Dashboard/index.html) directly in a browser
- direct file mode still works, but shared save/load falls back to browser local storage instead of the shared JSON file

## Next steps

- Replace the embedded metadata with parsed workbook and SCC imports
- Add per-product remediation recommendations
- Add evidence links per control
- Add pilot review workflow and status updates
