const controls = [
  {
    id: "V-253358",
    title: "Disable WDigest",
    category: "Auth & Crypto",
    lane: "QA",
    owner: "EUC",
    method: "Script",
    validation: "Registry state + SCC rescan + credential flow smoke test",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 1. Improved in the 36 to 45 jump and marked high-risk if skipped.",
    rollback: "Restore previous WDigest policy value and rescan."
  },
  {
    id: "V-253285",
    title: "Disable PowerShell 2.0",
    category: "PowerShell & Scripting",
    lane: "QA",
    owner: "InfoSec",
    method: "Script",
    validation: "Windows feature state + SCC rescan",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 2. Workbook says passed, but SCC shows fail to notapplicable and needs explicit interpretation.",
    rollback: "Re-enable feature only if an app dependency is confirmed."
  },
  {
    id: "V-253367",
    title: "Command line in process logs",
    category: "Audit & Logging",
    lane: "QA",
    owner: "InfoSec",
    method: "Script",
    validation: "Generate process events and confirm command-line capture",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 3. Improved in the first remediation jump and supports forensic depth.",
    rollback: "Remove the process creation command-line logging setting."
  },
  {
    id: "V-253414",
    title: "PowerShell script block logging",
    category: "PowerShell & Scripting",
    lane: "QA",
    owner: "InfoSec",
    method: "Script",
    validation: "Run a sample script and verify event logging output",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 4. Improved in the first remediation jump.",
    rollback: "Disable the script block logging policy and rescan."
  },
  {
    id: "V-253354",
    title: "IPv4 source routing off",
    category: "Network",
    lane: "QA",
    owner: "EUC",
    method: "Script",
    validation: "Registry check + network stack validation",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 5. Improved in the first remediation jump and is low-friction hardening.",
    rollback: "Restore prior TCPIP source-routing policy value."
  },
  {
    id: "V-253353",
    title: "IPv6 source routing off",
    category: "Network",
    lane: "QA",
    owner: "EUC",
    method: "Script",
    validation: "Registry check + IPv6 stack validation",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 6. Improved in the first remediation jump and mirrors the IPv4 protection.",
    rollback: "Restore prior IPv6 source-routing policy value."
  },
  {
    id: "V-253370",
    title: "Credential Guard",
    category: "Device & Hardware",
    lane: "QA",
    owner: "EUC",
    method: "Script",
    validation: "Virtualization security status + app compatibility smoke test",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 7. Already passing on the baseline evidence and retained in the high-risk pilot cohort.",
    rollback: "Back out the virtualization-based credential isolation setting."
  },
  {
    id: "V-253371, V-253426",
    title: "VBS / DMA protection",
    category: "Device & Hardware",
    lane: "QA",
    owner: "EUC",
    method: "Script",
    validation: "Kernel DMA protection + VBS state + SCC rescan",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 8. V-253371 was already aligned; V-253426 improved in the 45 to 51 jump.",
    rollback: "Remove the DMA and VBS enforcement settings if hardware conflicts appear."
  },
  {
    id: "V-253306, V-253317",
    title: "Audit: logon/logoff",
    category: "Audit & Logging",
    lane: "QA",
    owner: "InfoSec",
    method: "Script",
    validation: "Generate logon events and verify success/failure auditing",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 9. This group improved in the 45 to 51 jump through the audit batch.",
    rollback: "Restore the previous advanced audit policy settings."
  },
  {
    id: "V-253319, V-253324, V-278926, V-278931",
    title: "Audit: object access & file system",
    category: "Audit & Logging",
    lane: "QA",
    owner: "InfoSec",
    method: "Script",
    validation: "Exercise file share and removable storage events and verify logs",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 10. This audit set improved in the 45 to 51 jump.",
    rollback: "Revert the object-access audit settings and rescan."
  },
  {
    id: "V-253325, V-253329, V-278932, V-278933",
    title: "Audit: policy change & privilege use",
    category: "Audit & Logging",
    lane: "QA",
    owner: "InfoSec",
    method: "Script",
    validation: "Trigger admin and policy-change events and verify logging",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 11. The `V-278932` component is visible in the second jump evidence.",
    rollback: "Restore the prior privilege-use and policy-change audit settings."
  },
  {
    id: "V-253330, V-253336",
    title: "Audit: system events",
    category: "Audit & Logging",
    lane: "QA",
    owner: "InfoSec",
    method: "Script",
    validation: "Generate system integrity and driver events and confirm logs",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 12. Improved in the 45 to 51 jump.",
    rollback: "Restore prior audit system policy values."
  },
  {
    id: "V-253259, V-253257",
    title: "BitLocker baseline (OS disk)",
    category: "Device & Hardware",
    lane: "QA",
    owner: "EUC",
    method: "Script",
    validation: "Protection status + escrow check + reboot verification",
    risk: "High",
    deviceA: "#",
    deviceB: "docs/DEVICE_B_SCAN_DELTA.md",
    note: "Pilot row 13. The OS-disk BitLocker baseline improved in the 36 to 45 jump and remains core pilot scope.",
    rollback: "Suspend or revert BitLocker settings only with recovery-key confirmation."
  }
];

const filters = {
  lane: document.getElementById("laneFilter"),
  owner: document.getElementById("ownerFilter"),
  method: document.getElementById("methodFilter"),
  category: document.getElementById("categoryFilter")
};

const summaryCards = document.getElementById("summaryCards");
const controlsTable = document.getElementById("controlsTable");

function uniqueValues(key) {
  return [...new Set(controls.map(control => control[key]))].sort();
}

function fillSelect(select, values) {
  select.innerHTML = "";
  const all = document.createElement("option");
  all.value = "All";
  all.textContent = "All";
  select.appendChild(all);

  values.forEach(value => {
    const option = document.createElement("option");
    option.value = value;
    option.textContent = value;
    select.appendChild(option);
  });
}

function laneClass(lane) {
  return `lane-${lane.toLowerCase()}`;
}

function matchesFilters(control) {
  return Object.entries(filters).every(([key, element]) => {
    return element.value === "All" || control[key] === element.value;
  });
}

function renderSummary(items) {
  const lanes = ["Ready", "QA", "Hold"];
  summaryCards.innerHTML = lanes.map(lane => {
    const count = items.filter(item => item.lane === lane).length;
    return `
      <article class="summary-card">
        <strong>${count}</strong>
        <span class="pill ${laneClass(lane)}">${lane}</span>
      </article>
    `;
  }).join("");
}

function renderTable(items) {
  controlsTable.innerHTML = items.map(control => `
    <tr>
      <td>
        <strong>${control.id}</strong><br>
        ${control.title}
        <small>${control.note}</small>
      </td>
      <td><span class="pill ${laneClass(control.lane)}">${control.lane}</span></td>
      <td>${control.owner}</td>
      <td>${control.method}</td>
      <td>
        ${control.validation}
        <small>Rollback: ${control.rollback}</small>
      </td>
      <td><span class="risk">${control.risk}</span></td>
      <td>
        <div class="evidence-links">
          <a href="${control.deviceA}">Device A</a>
          <a href="${control.deviceB}">Device B</a>
        </div>
      </td>
    </tr>
  `).join("");
}

function render() {
  const filtered = controls.filter(matchesFilters);
  renderSummary(filtered);
  renderTable(filtered);
}

fillSelect(filters.lane, uniqueValues("lane"));
fillSelect(filters.owner, uniqueValues("owner"));
fillSelect(filters.method, uniqueValues("method"));
fillSelect(filters.category, uniqueValues("category"));

Object.values(filters).forEach(select => {
  select.addEventListener("change", render);
});

render();
