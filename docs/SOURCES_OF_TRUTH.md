# Sources Of Truth

This project should use a layered source-of-truth model instead of relying on a single file.

## Primary sources

- Local SCC XCCDF result XML files under `Harding_STIG/Device B Scan/.../Results/SCAP/XML/`
  - These are the most reliable source for actual pass/fail state on Device B.
  - Use these for scan deltas, score progression, and exact control status.
- Local Windows 11 STIG catalog:
  - `Harding_STIG/microsoft-windows-11-security-technical-implementation-guide.csv`
  - Use this for control metadata:
    - finding ID
    - severity
    - STIG version ID
    - title
    - check text
    - fix text
- Local selected-controls trackers:
  - `Harding_STIG/master_stig_35.csv`
  - `Harding_STIG/Win11_STIG_Master35.csv`
  - Use these for pilot selection, tiers, categories, and implementation notes.
  - Within `Win11_STIG_Master35.csv`, the `Win11_STIG_Pilot` sheet is the authoritative Device B QA pilot source.
  - The top `14` worksheet rows contain the header plus the initial Device B QA set.
  - That means the initial high-risk Device B QA pilot is `13` control entries.
  - Those control rows are all marked `Risk If Not Implemented = High`.

## External reference sources

- DISA Cyber Exchange / official DISA STIG downloads
  - Use as the authoritative upstream source for official STIG releases.
- STIG Viewer
  - `https://www.stigviewer.com/stigs`
  - Use as a fast lookup index for:
    - finding pages
    - STIG dates
    - public check/fix text review
  - Do not treat it as the only authority if local or official DISA artifacts disagree.

## Current known references

- STIG Viewer currently lists:
  - `Microsoft Windows 11 Security Technical Implementation Guide` with a public date of `2025-05-15`
  - product STIG pages for Chrome, Edge, Adobe Reader, Firefox, and others
- Local SCC Windows 11 result files reference the benchmark stream:
  - `Microsoft_Windows_11_STIG-002.007.016`
- Local Windows 11 source CSV includes the full finding catalog used for mapping titles and fixes.

## Working rule

Use the sources in this order:

1. SCC XCCDF XML for actual device status
2. Local STIG catalog CSV for finding metadata
3. `Win11_STIG_Master35.csv` `Win11_STIG_Pilot` sheet for Device B pilot scope
4. Other local master tracker files for broader selection and ownership notes
5. Official DISA downloads for upstream validation
6. STIG Viewer for fast lookup and linking

## Current file observations

- `master_stig_35.csv` is a normal CSV and currently contains `34` rows, not 35.
- `Win11_STIG_Master35.csv` is actually an Excel workbook saved with a `.csv` extension.
  - It contains these sheets:
    - `master_stig_controls`
    - `Win11_STIG_Master35_Final_2026`
    - `Win11_STIG_Pilot`
  - `Win11_STIG_Pilot` worksheet rows `2-14` define the current Device B QA pilot:
    - `V-253358` Disable WDigest
    - `V-253285` Disable PowerShell 2.0
    - `V-253367` Command line in process logs
    - `V-253414` PowerShell script block logging
    - `V-253354` IPv4 source routing off
    - `V-253353` IPv6 source routing off
    - `V-253370` Credential Guard
    - `V-253371, V-253426` VBS and DMA protection
    - `V-253306, V-253317` Audit logon and logoff
    - `V-253319, V-253324, V-278926, V-278931` Audit object access and file system
    - `V-253325, V-253329, V-278932, V-278933` Audit policy change and privilege use
    - `V-253330, V-253336` Audit system events
    - `V-253259, V-253257` BitLocker baseline

This workbook-extension mismatch should be handled explicitly in any automated import step.
