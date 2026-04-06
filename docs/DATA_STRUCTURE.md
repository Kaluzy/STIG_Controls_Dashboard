# Data Structure

This app now separates presentation from project data and operating rules.

## Current layers

- `data/controls-data.js`
  - selected Windows 11 control set
  - control validation metadata
  - control technical setting and deployment path text

- `data/waves-data.js`
  - current pilot wave identity
  - Device B pilot control scope

- `data/config-data.js`
  - team ownership mapping by category
  - control-specific ownership overrides
  - scoring maps and priority bucket rules
  - shared team catalog
  - lifecycle stage options

- `data/baseline-data.js`
  - baseline failed controls from the Device B 36% evidence set

- `data/infosec-config.js`
  - backlog-specific priority overrides
  - baseline scoring weights
  - known rule-level focus overrides
  - severity, priority, and paging option lists

- `data/infosec-content.js`
  - backlog owner inference rules
  - backlog deployment-path wording
  - human-readable finding summaries
  - why-it-matters text
  - focus guidance wording

- `data/view-meta.js`
  - tab titles
  - explainer copy
  - summary pill text for each main view

- `data/reference-sources.js`
  - DISA, NIST, and benchmark reference links

- `data/schema/controls.schema.json`
  - target normalized control catalog schema

- `data/schema/scan-results.schema.json`
  - target normalized scan result schema

- `data/examples/normalized-scan-result.example.json`
  - example output shape for future parser work

- `data/generated/`
  - parser outputs consumed by the dashboard when available

## What still lives in `index.html`

- rendering logic
- filter state
- shared-state persistence
- tab composition and layout behavior

## Ingestion planning docs

- [SOURCE_OF_TRUTH_MODEL.md](./SOURCE_OF_TRUTH_MODEL.md)
- [SCAN_INGESTION_ARCHITECTURE.md](./SCAN_INGESTION_ARCHITECTURE.md)
- [INGESTION_BUILD_PLAN.md](./INGESTION_BUILD_PLAN.md)
- [SCAN_DROP_USAGE.md](./SCAN_DROP_USAGE.md)

## Scan folder scaffold

- `scans/inbox/`
- `scans/processed/`
- `scans/failed/`

## Why this structure is better

- the page is no longer the primary source of truth
- pilot scope can be reviewed without opening app code
- ownership and scoring can be changed without editing layout markup
- the app stays static and GitHub Pages-safe
- local file opening still works because these are script-loaded data files, not async fetch calls

## Next likely split

- move backlog wording heuristics into a dedicated content/rules file
- then reduce `index.html` to mostly rendering and event handling
