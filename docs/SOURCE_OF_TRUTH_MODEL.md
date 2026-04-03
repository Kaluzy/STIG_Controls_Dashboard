# Source of Truth Model

The control center should use a layered source-of-truth model.

## 1. Official benchmark authority

Use DISA as the benchmark authority for STIG content.

- DISA STIG downloads:
  - https://public.cyber.mil/stigs/downloads/
- Use this for:
  - official STIG releases
  - SCAP/XCCDF benchmark packages
  - release/version dates
  - official checklist content

## 2. Standards authority

Use NIST as the standards authority for the SCAP/XCCDF format.

- XCCDF 1.2:
  - https://www.nist.gov/publications/specification-extensible-configuration-checklist-description-format-xccdf-version-12
- SCAP 1.2:
  - https://www.nist.gov/publications/technical-specification-security-content-automation-protocol-scap-scap-version-12

Use this for:
- parser design
- result normalization
- understanding what fields in the XML actually mean

## 3. Operational evidence authority

Use your own SCC/XCCDF result files as the truth for actual device state.

Use this for:
- pass/fail status
- regressions
- deltas between scans
- host-specific evidence
- test chronology

## 4. Reference lookup layer

STIG Viewer is useful as a fast lookup and reading surface, but not the core source of truth.

- STIG Viewer:
  - https://www.stigviewer.com/stigs/microsoft-windows-11-security-technical-implementation-guide

Use this for:
- fast control lookup
- human review
- browsing check/fix text

Do not make live scraping of STIG Viewer the primary dependency for the app.

## 5. Your control center

Your app should be the operational system of record for:
- pilot scope
- ownership
- priority
- QA status
- release readiness
- decision history
- rollback notes
- linked evidence

## Practical rule

When sources disagree:

1. DISA defines what the control is
2. NIST defines how the scan/result format works
3. your SCC/XCCDF results define what happened on the device
4. your control center defines what the team decided to do about it
