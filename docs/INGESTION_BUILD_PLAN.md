# Ingestion Build Plan

## Objective

Build the first in-house ingestion path so the control center can consume SCC/XCCDF scan outputs and update the dashboard from normalized evidence instead of hand-maintained mappings.

## Source model

- DISA:
  - benchmark authority
  - benchmark versions
  - official STIG content
- NIST:
  - XCCDF / SCAP structure authority
- local SCC/XCCDF scans:
  - actual device evidence

## Phase 1

### Deliverables

- scan inbox folder convention
- parser contract
- normalized output JSON
- dashboard read-path for normalized scan results

### Folder convention

```text
scans/
  inbox/
    device-b/
      2026-04-01/
        windows11-xccdf.xml
  processed/
  failed/
```

### Parser outputs

- normalized scan metadata
- normalized per-control results
- prior-vs-current delta summary

### Dashboard outcomes

- regressions become first-class records
- fixed controls update automatically
- evidence sections link to the scan file and timestamp

## Phase 2

- upload endpoint in `server.js`
- parser execution on drop/upload
- shared normalized state files under `data/generated/`

## Phase 3

- multi-product benchmarks
- Device A vs Device B comparison generation
- leadership weekly summary generation

## Important rule

The parser should never overwrite:
- owner
- note
- decision history
- lifecycle stage

It should only update:
- evidence
- benchmark result status
- deltas
- timestamps
