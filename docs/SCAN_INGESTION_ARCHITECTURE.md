# Scan Ingestion Architecture

## Goal

Allow a team to drop new SCC/XCCDF scan results into a centralized location and have the control center update:

- dashboard status
- regressions
- fixed controls
- new failures
- device history
- pilot readiness
- evidence links

## Target flow

1. `scan inbox`
   - a shared folder or upload endpoint receives new scan files

2. `parser`
   - parse XCCDF/XML
   - extract:
     - hostname
     - benchmark
     - benchmark version
     - scan timestamp
     - rule ID
     - V-ID
     - result status

3. `normalizer`
   - map each result into a normalized structure:
     - device
     - benchmark
     - scan
     - control reference
     - result

4. `matcher`
   - match results to the control-center catalog using:
     - V-ID
     - Rule ID
     - benchmark

5. `delta engine`
   - compare current scan to prior scans for the same device and benchmark
   - classify:
     - new fail
     - fixed
     - regressed
     - unchanged

6. `control center updater`
   - update dashboard surfaces:
     - readiness
     - backlog
     - pilot wave
     - regression flags
     - evidence sections

## Minimum data model

- `controls`
- `control_references`
- `devices`
- `scans`
- `scan_results`
- `waves`
- `decisions`

## Recommended folder model

```text
STIG_Project/
  scans/
    inbox/
    processed/
    failed/
  evidence/
    device_a/
    device_b/
  data/
    controls/
    scans/
    decisions/
```

## MVP implementation

Phase 1:
- local parser script
- file-drop folder
- normalized JSON output
- dashboard reads normalized JSON

Phase 2:
- small server endpoint for uploads
- automatic processing
- shared state + evidence history

Phase 3:
- product benchmarks beyond Windows 11
- richer reporting and comparison
- cross-device baselines

## Important modeling rule

Never treat a scan result as the same thing as program status.

Keep these separate:
- benchmark status
- implementation status
- QA status
- release status

That avoids the exact confusion you called out with `QA Passed`.
