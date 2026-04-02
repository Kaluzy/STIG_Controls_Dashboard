# Project Charter

## Name

STIG Pilot Dashboard

## Goal

Create a simple operating surface for EUC, InfoSec, sysadmins, QA, and leadership to manage the STIG pilot without losing ownership, validation, or rollback clarity.

## Success criteria

- Wave 1 controls are visible and categorized
- `Ready`, `QA`, and `Hold` lanes are obvious
- Device A and Device B evidence links are visible
- Ownership and implementation method are explicit
- Rollback notes are easy to inspect

## Non-goals

- No one-click production remediation
- No automatic broad deployment workflows
- No mixing endpoint-owned and domain-owned controls

## Initial data model

Each control should support:

- Control ID
- Title
- Category
- Tier
- Lane
- Owner team
- Implementation method
- Validation method
- Risk level
- Device A evidence
- Device B evidence
- Remediation note
- Rollback note
