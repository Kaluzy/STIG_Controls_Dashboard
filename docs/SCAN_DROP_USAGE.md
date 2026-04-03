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

This folder structure is a project scaffold only.
The automated parser is not implemented yet.
