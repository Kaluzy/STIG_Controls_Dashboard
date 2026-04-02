# Roadmap Alignment

This project follows the Notion pages:

- `RoadMap - Pilot`
- `North Star - STIG Pilot`
- `Phase 2 - Pilot Plan`
- `Implementation Guide - Intune and GPO`
- `Web App Backlog and Dashboard Ideas`

## Execution rules

- Do not treat this as a broad rollout tool.
- Device A is the full-hardening reference device.
- Device B is the balanced pilot baseline.
- Wave 1 is the only active implementation scope until validated.
- Tier 1 and validated Tier 2 controls move first.
- Tier 3 and cross-team controls remain on hold pending approval.
- Every control requires:
  - owner
  - implementation path
  - validation method
  - evidence
  - rollback path

## Delivery bias

- Dashboard and evidence first
- Remediation visibility before automation
- Pilot groups only
- Weekly review loop for passed, failed, changed, and blocked items

## Policy ownership

- Intune where endpoint ownership is correct
- GPO where on-prem domain ownership is correct
- Registry edits only for lab validation
