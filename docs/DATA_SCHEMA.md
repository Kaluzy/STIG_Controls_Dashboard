# Data Schema

## Purpose

This schema turns the app from a report viewer into a lifecycle-managed control system.

## File split

- `data/controls.json`
- `data/waves.json`
- `data/tests.json`
- `data/owners.json`
- `data/reports.json`
- `data/decisions.json`

## Control record

```json
{
  "control_id": "V-253358",
  "benchmark_id": "WN11-CC-000038",
  "title": "Disable WDigest",
  "product": "Windows 11",
  "category": "Auth & Crypto",
  "tier": "Tier 1",
  "wave": "Wave 1",
  "lane": "Ready",
  "lifecycle_stage": "QA Passed",
  "validation_state": "Scan-Proven",
  "owner_team": "Endpoint Security Engineering",
  "owner_person": "TBD",
  "cross_team_dependency": [],
  "security_value": 5,
  "user_impact": 1,
  "support_impact": 1,
  "operational_risk": 1,
  "active_threat_relevance": true,
  "priority_score": 91,
  "priority_bucket": "Highest Value",
  "why_selected": "High-value credential hardening with low operational friction.",
  "implementation_method": "Group Policy",
  "policy_location": "Computer Config >> Admin Templates >> MS Security Guide >> WDigest Authentication = Disabled",
  "remediation_steps": [
    "Set UseLogonCredential to 0",
    "Apply through policy-backed device baseline"
  ],
  "rollback_steps": [
    "Revert policy setting",
    "Rescan and confirm state"
  ],
  "validation_steps": [
    "Verify registry value",
    "Run SCC rescan",
    "Confirm no dependent app breakage"
  ],
  "smoke_test_checklist": [
    "Standard user logon succeeds",
    "VPN/auth flows unaffected"
  ],
  "pre_scan_link": "scans/device_b/pre/windows11.xml",
  "post_scan_link": "scans/device_b/post/windows11.xml",
  "evidence_links": [
    "reports/device_b/windows11_36.html",
    "reports/device_b/windows11_51.html"
  ],
  "script_refs": [
    "scripts/DeviceB-Product-Hardening.ps1"
  ],
  "qa_status": "Passed",
  "release_status": "RFC Ready",
  "status": "Active",
  "notes": "Validated on Device B and suitable for pilot release.",
  "decision_log_ids": [
    "DEC-2026-04-01-001"
  ],
  "last_updated": "2026-04-01",
  "updated_by": "Codex"
}
```

## Wave record

```json
{
  "wave_id": "wave-1",
  "name": "Wave 1",
  "device_target": "Device B",
  "purpose": "High-value pilot controls with low or acceptable friction.",
  "control_ids": ["V-253358", "V-253367"],
  "owner_teams": ["Endpoint Security Engineering", "InfoSec / SOC"],
  "status": "Active",
  "qa_status": "In Progress",
  "release_status": "Not Ready",
  "blockers": ["Security log sizing", "VBS regression"],
  "last_updated": "2026-04-01"
}
```

## Test record

```json
{
  "test_id": "TEST-2026-04-01-001",
  "control_id": "V-253358",
  "device": "Device B",
  "test_type": "Smoke Test",
  "result": "Passed",
  "tester": "TBD",
  "evidence_links": [
    "reports/smoke/device_b_auth_validation.md"
  ],
  "notes": "No user logon impact observed.",
  "date": "2026-04-01"
}
```

## Owner record

```json
{
  "team_id": "endpoint-security-engineering",
  "team_name": "Endpoint Security Engineering",
  "primary_contact": "TBD",
  "secondary_contact": "TBD",
  "scope": [
    "Windows hardening",
    "Device security policy"
  ]
}
```

## Decision log record

```json
{
  "decision_id": "DEC-2026-04-01-001",
  "control_id": "V-253358",
  "title": "Keep in Wave 1",
  "decision": "Approved for pilot release",
  "reason": "High value and scan-proven with low friction.",
  "participants": [
    "Endpoint Security Engineering",
    "InfoSec / SOC"
  ],
  "date": "2026-04-01",
  "links": [
    "reports/weekly/2026-04-01.md"
  ]
}
```

## Export strategy

- JSON
  - app import/export and portability
- CSV
  - spreadsheet review and management workflows
- Markdown
  - weekly updates, leadership summaries, and decision archives

## SQLite recommendation

SQLite becomes useful when:

- multiple data files start drifting
- status history grows
- advanced filtering and joins become cumbersome in flat JSON
- team collaboration expands beyond one shared JSON state file

Recommendation:

- stay JSON-first in v1
- design schema so SQLite can be adopted in v2 without rethinking field names
