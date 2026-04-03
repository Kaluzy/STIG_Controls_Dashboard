window.STIG_CONTROL_CONFIG = {
  teamByCategory: {
    "Auth & Crypto": "Identity & Access Engineering",
    "PowerShell & Scripting": "Endpoint Security Engineering",
    "Audit & Logging": "Security Operations & Detection",
    "Apps & Features": "Endpoint Security Engineering",
    "Account & Logon": "Identity & Access Engineering",
    "Network": "Infrastructure & Trust Services",
    "Passwords": "Identity & Access Engineering",
    "Device & Hardware": "Endpoint Security Engineering",
    "Remote Access": "Infrastructure & Trust Services",
    "User Rights & Local Accounts": "Identity & Access Engineering"
  },
  controlOverrides: {
    "V-253259 / V-253257": {
      owner_team: "Endpoint Security Engineering",
      owner_person: "Device B pilot owner",
      cross_team_dependency: "InfoSec sign-off",
      decision_log: [
        "Kept in Wave 1 because BitLocker materially improved the Device B score and the device remained usable.",
        "Requires change-control discipline for rollback because this affects disk protection posture."
      ]
    },
    "V-253371 / V-253426": {
      owner_team: "Endpoint Security Engineering",
      owner_person: "Platform security owner",
      cross_team_dependency: "InfoSec review and hardware validation",
      decision_log: [
        "Keep in Wave 1, but do not call it complete while the VBS regression remains unresolved.",
        "DMA protection improved, but VBS proof split must be explained before release."
      ]
    },
    "V-253337 / V-253339": {
      owner_team: "Security Operations & Detection",
      owner_person: "Audit policy owner",
      cross_team_dependency: "Endpoint Engineering script correction",
      decision_log: [
        "Blocked because the Security log sizing requirement is still wrong in the remediation batch.",
        "Must be rescanned after the exact 1024000 KB setting is applied."
      ]
    }
  },
  securityValueMap: { High: 5, Medium: 3, Low: 1 },
  frictionValueMap: { None: 1, Noticeable: 3, Disruptive: 5 },
  riskValueMap: { High: 5, Medium: 3, Low: 1 },
  teamOptions: [
    "Endpoint Security Engineering",
    "Identity & Access Engineering",
    "Security Operations & Detection",
    "Infrastructure & Trust Services",
    "Browser & Application Engineering"
  ],
  lifecycleOptions: [
    "Candidate",
    "Prioritized",
    "Owner Assigned",
    "Ready for Test",
    "Implemented in Lab",
    "Smoke Tested",
    "QA Requested",
    "QA Passed",
    "RFC Ready",
    "Released",
    "Rolled Back",
    "Deferred"
  ],
  priorityBuckets: [
    { min: 55, label: "Highest Value" },
    { min: 42, label: "Safe Quick Win" },
    { min: 30, label: "Needs Review" },
    { min: -9999, label: "Too Risky Right Now" }
  ]
};
