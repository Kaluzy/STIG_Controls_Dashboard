window.STIG_INFOSEC_CONFIG = {
  scoreBySeverity: { High: 5, Medium: 3, Low: 1 },
  scoreByPriority: { High: 5, Medium: 3, Low: 1 },
  defaultPriorityBySeverity: { High: "High", Medium: "Medium", Low: "Low" },
  ruleOverrides: {
    "WN11-AU-000505": { priority: "High", owner: "Security Operations & Detection" },
    "WN11-00-000031": { priority: "High", owner: "Endpoint Security Engineering" },
    "WN11-00-000032": { priority: "Medium", owner: "Endpoint Security Engineering" },
    "WN11-00-000155": { priority: "High", owner: "Endpoint Security Engineering" },
    "WN11-00-000125": { priority: "Medium", owner: "Endpoint Security Engineering" },
    "WN11-AC-000020": { priority: "Medium", owner: "Identity & Access Engineering" },
    "WN11-AC-000025": { priority: "Medium", owner: "Identity & Access Engineering" },
    "WN11-AC-000030": { priority: "Low", owner: "Identity & Access Engineering" },
    "WN11-AC-000035": { priority: "Medium", owner: "Identity & Access Engineering" },
    "WN11-CC-000330": { priority: "High", owner: "Endpoint Security Engineering" },
    "WN11-CC-000345": { priority: "High", owner: "Endpoint Security Engineering" },
    "WN11-SO-000205": { priority: "High", owner: "Identity & Access Engineering" },
    "WN11-SO-000230": { priority: "Medium", owner: "Identity & Access Engineering" }
  },
  focusOverrides: {
    "WN11-AU-000505": "Correct the script first. The current batch sets 32768 KB, but the Security log requirement is 1024000 KB or greater."
  }
};
