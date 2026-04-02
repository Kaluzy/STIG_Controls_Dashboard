# Tool Prompt

Use this prompt when you want to explain, extend, or rebuild the STIG Pilot Control Center with the same intent.

```text
Build an internal STIG Pilot Control Center for a Windows 11 hardening program.

The app is not just a dashboard. It is an evidence-first hardening control center.

The tool must do five things well:
1. Show the selected Windows 11 control set in a clear executive and engineering summary.
2. Track the Device B pilot wave using the real SCC progression from 36% to 45% to 51%.
3. Turn baseline failed controls into a shared execution backlog with owner, priority, notes, recommendation, and evidence context.
4. Keep V-ID as the primary identifier while still showing the WN11 benchmark ID for SCC traceability.
5. Support shared updates with small server-side persistence plus JSON import/export.
6. Support wave-based execution and release readiness, not just a static backlog.

Design goals:
- premium but readable internal operations UI
- plain-English wording for nontechnical stakeholders
- decision-first information architecture
- strong filter and navigation model
- no confusing tab sprawl
- same data visible through different decision lenses: summary, pilot, backlog, library, matrix

Core views:
- Command Center: selected controls, validation posture, high-level readiness
- Pilot Wave: Device B QA controls only
- Operations Backlog: all baseline failed controls with smart filtering, ownership, priority, notes, recommendation, and team participation
- Control Library: browse controls by category
- Risk Matrix: security value versus user friction
- Release Readiness: stage-based movement from candidate to pilot ring and beyond

Core data:
- local SCC/XCCDF XML scan outputs from Device B
- Win11_STIG_Master35 workbook content
- script validation findings
- generated baseline JSON with V-ID and WN11 mapping

Required behavior:
- use V-ID as the main key shown to the user
- keep benchmark ID visible as secondary reference
- allow ownership labels such as Endpoint Security Engineering, Identity & Access Engineering, Security Operations & Detection, Infrastructure & Trust Services, and Browser & Application Engineering
- allow note capture and priority labeling
- support shared save/load through a lightweight file-backed server
- support JSON export/import for backup and rotation
- separate implemented, scan-proven, needs validation, failed/regression, and blocked-by-ownership
- support stage progression like Candidate, Peer Review, EUC/InfoSec Testing, QA, RFC, Pilot Ring, Full Ring, Closed

The app should help security, endpoint, identity, infrastructure, and leadership all work from the same source of operational truth.
```
