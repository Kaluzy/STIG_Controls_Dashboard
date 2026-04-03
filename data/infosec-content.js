window.STIG_INFOSEC_CONTENT = {
  inferOwner(ruleId, title) {
    if (ruleId.includes('-AU-')) return 'Security Operations & Detection';
    if (ruleId.includes('-PK-')) return 'Infrastructure & Trust Services';
    if (ruleId.includes('-UR-')) return 'Identity & Access Engineering';
    if (ruleId.includes('-AC-')) return 'Identity & Access Engineering';
    if (title.includes('NTLM') || title.includes('Kerberos') || title.includes('LanMan') || title.includes('SMB') || title.includes('SAM')) return 'Identity & Access Engineering';
    if (title.includes('certificate') || title.includes('Root CA')) return 'Infrastructure & Trust Services';
    if (title.includes('Chrome') || title.includes('Edge') || title.includes('Firefox') || title.includes('Office') || title.includes('Explorer')) return 'Browser & Application Engineering';
    return 'Endpoint Security Engineering';
  },

  inferMethod(ruleId, title) {
    if (ruleId.includes('-PK-')) return 'Central certificate distribution through trust-store management, GPO, or device configuration profiles';
    if (ruleId.includes('-AU-')) return 'Advanced Audit Policy through GPO or Intune Settings Catalog with a retest in SCC';
    if (ruleId.includes('-UR-') || ruleId.includes('-AC-') || title.includes('User right') || title.includes('Account')) return 'Domain-backed security policy with IAM sign-off, not a one-off local-only change';
    if (title.includes('BitLocker')) return 'Intune Endpoint Security or GPO BitLocker policy';
    if (title.includes('WinRM') || title.includes('Remote Desktop') || title.includes('RPC')) return 'Administrative Templates or security baselines, validated against admin workflow impact';
    if (title.includes('PowerShell') || title.includes('Copilot') || title.includes('consumer') || title.includes('Telemetry') || title.includes('Game Recording')) return 'Administrative Templates via Intune or GPO, with plain-English release notes for users';
    return 'Policy-backed endpoint configuration, documented in a reusable implementation standard';
  },

  summarizeFinding(ruleId, title) {
    if (ruleId.includes('-AU-')) return 'The device is missing one or more required audit events, so security evidence is incomplete.';
    if (ruleId.includes('-AC-')) return 'The local or domain account policy is weaker than the STIG baseline expects.';
    if (ruleId.includes('-UR-')) return 'A privileged user-right assignment is broader than it should be.';
    if (title.includes('BitLocker PIN')) return 'The startup protection requirement for BitLocker is not fully enforced yet.';
    if (title.includes('Copilot')) return 'Windows Copilot is still available or not fully blocked for the tested state.';
    if (title.includes('Remote Desktop') || title.includes('WinRM') || title.includes('RPC')) return 'A remote administration control is still more permissive than the STIG requires.';
    if (title.includes('certificate') || title.includes('Root CA')) return 'Required trust-store certificates are missing or not placed in the expected store.';
    return title.replace(/\s*must\s+/i, ' currently does not ').replace(/\.$/, '') + '.';
  },

  inferWhy(ruleId, title) {
    if (ruleId.includes('-AU-')) return 'This improves the quality of security evidence, which makes investigations, compliance reviews, and leadership reporting much easier to trust.';
    if (ruleId.includes('-AC-')) return 'This reduces weak password behavior and makes brute-force or password-reuse attacks materially harder.';
    if (ruleId.includes('-UR-')) return 'This narrows where privileged accounts can be used and reduces the chance of avoidable lateral movement.';
    if (title.includes('BitLocker')) return 'Protects the device before Windows starts and limits data loss if a laptop is lost or stolen.';
    if (title.includes('Remote Desktop') || title.includes('WinRM') || title.includes('RPC')) return 'This closes common remote administration abuse paths, but it should be communicated clearly because it can affect operational habits.';
    if (title.includes('certificate') || title.includes('Root CA')) return 'This keeps machine trust aligned with enterprise and DoD certificate expectations so devices do not make the wrong trust decision.';
    if (title.includes('Telemetry') || title.includes('consumer') || title.includes('Copilot')) return 'This removes unnecessary consumer or cloud-facing behavior from a business workstation and reduces data exposure.';
    return 'This is part of a cleaner Windows baseline and lowers attack surface without requiring a full hardening posture everywhere at once.';
  },

  inferFocus(ruleId, title, focusOverrides) {
    if (focusOverrides[ruleId]) return focusOverrides[ruleId];
    if (title.includes('BitLocker PIN')) return 'Keep out of balanced pilot unless boot-time UX impact is accepted.';
    if (title.includes('PowerShell 2.0')) return 'Treat carefully: SCC may report this as fail even when the feature is absent.';
    if (title.includes('Copilot')) return 'Baseline shows fail; the final device moved. Verify whether policy landed for all users.';
    if (title.includes('Bluetooth')) return 'High false-positive risk for business peripherals. Require device-role decision before blanket enforcement.';
    if (title.includes('WinRM') || title.includes('Remote Desktop')) return 'Good security value, but validate admin workflows before broad rollout.';
    if (ruleId.includes('-PK-')) return 'This needs central trust-store ownership. Do not solve it with one-off scripting on a single machine.';
    return 'Assign the right owner, pick the durable implementation method, and only mark it complete after an SCC retest.';
  }
};
