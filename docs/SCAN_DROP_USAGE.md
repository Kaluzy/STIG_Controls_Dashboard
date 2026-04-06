# Scan Drop Usage

Use the following folders for the future ingestion flow:

- `scans/inbox/`
  - place newly exported SCC/XCCDF/XML files here

- `scans/processed/`
  - parsed files move here after successful normalization

- `scans/failed/`
  - files move here if parsing fails or matching is incomplete

## Intended future workflow

1. export scan result from SCC or another SCAP tool
2. drop XML into `scans/inbox/<device>/<date>/`
3. parser reads file and normalizes benchmark results
4. dashboard data updates from normalized outputs
5. processed scan is archived under `scans/processed/`

## Current state

The first parser utility now exists.

## Current parser

- [tools/parse-xccdf.ps1](/c:/Users/kaluz/OneDrive/Documents/AI%20Playground/STIG-Pilot-Dashboard/tools/parse-xccdf.ps1)

### What it does

- reads the latest XML in `scans/inbox/` or a specific file path
- parses benchmark title, version, device, timestamp, and rule results
- writes:
  - `data/generated/latest-scan-results.json`
  - `data/generated/latest-baseline-failed.json`
  - `data/generated/latest-baseline-data.js`
  - `data/generated/scans/<scan-id>.json`

### Why it matters

The dashboard now prefers `data/generated/latest-baseline-data.js` when it exists, so a parsed scan can update the Operations Backlog without hand-editing the page.

## Run command

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\parse-xccdf.ps1
```

## Specific file example

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\parse-xccdf.ps1 -InputPath ".\scans\inbox\device-b\2026-04-01\windows11-xccdf.xml"
```
