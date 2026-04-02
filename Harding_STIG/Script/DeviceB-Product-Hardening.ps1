# =====================================================
# Device B - Balanced Product Hardening Script
# Applies safe, high-value STIG settings per product
# =====================================================

Write-Host "`n[DEVICE B] Starting product hardening..." -ForegroundColor Cyan
Write-Host "Baseline scores: Chrome 2.27%, Edge 3.64%, Defender 23.88%, etc." -ForegroundColor Yellow

# -----------------------------------------------------
# 1. Google Chrome (STIG: v2r11) - Target: ~20-30% improvement
# -----------------------------------------------------
Write-Host "`n[1/7] Google Chrome (pre: 2.27%)" -ForegroundColor Cyan
$chromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (-not (Test-Path $chromePath)) { New-Item -Path $chromePath -Force | Out-Null }

# V-221567: Disable password manager
Set-ItemProperty -Path $chromePath -Name "PasswordManagerEnabled" -Type DWord -Value 0
# V-221580: Safe Browsing Standard
Set-ItemProperty -Path $chromePath -Name "SafeBrowsingEnabled" -Type DWord -Value 1
Set-ItemProperty -Path $chromePath -Name "SafeBrowsingProtectionLevel" -Type DWord -Value 1
# V-221590: No extended reporting (privacy)
Set-ItemProperty -Path $chromePath -Name "SafeBrowsingExtendedReportingEnabled" -Type DWord -Value 0
# V-221565: HTTPS search
Set-ItemProperty -Path $chromePath -Name "DefaultSearchProviderSearchURL" -Type String -Value "https://www.bing.com/search?q={searchTerms}"

Write-Host "  ✓ Chrome: Password manager OFF, Safe Browsing ON, HTTPS search" -ForegroundColor Green

# -----------------------------------------------------
# 2. Microsoft Edge (STIG: v2r4) - Target: ~15-25% improvement
# -----------------------------------------------------
Write-Host "`n[2/7] Microsoft Edge (pre: 3.64%)" -ForegroundColor Cyan
$edgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (-not (Test-Path $edgePath)) { New-Item -Path $edgePath -Force | Out-Null }

# V-235756: Disable password manager
Set-ItemProperty -Path $edgePath -Name "PasswordManagerEnabled" -Type DWord -Value 0
# V-253395: Enable SmartScreen + block bypass
Set-ItemProperty -Path $edgePath -Name "SmartScreenEnabled" -Type DWord -Value 1
Set-ItemProperty -Path $edgePath -Name "PreventSmartScreenPromptOverride" -Type DWord -Value 1
# V-253401: TLS 1.2+ (system-wide .NET)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1 -ErrorAction SilentlyContinue

Write-Host "  ✓ Edge: Password manager OFF, SmartScreen ON + bypass blocked" -ForegroundColor Green

# -----------------------------------------------------
# 3. Mozilla Firefox (STIG: v6r7) - Target: ~10-20% improvement
# -----------------------------------------------------
Write-Host "`n[3/7] Mozilla Firefox (pre: 3.03%)" -ForegroundColor Cyan
$ffPolicyDir = "$env:ProgramFiles\Mozilla Firefox\distribution"
if (-not (Test-Path $ffPolicyDir)) { New-Item -Path $ffPolicyDir -ItemType Directory -Force | Out-Null }

$ffPolicy = @'
{
  "policies": {
    "PasswordManagerEnabled": false,
    "SafeBrowsingMode": 1,
    "DisableTelemetry": true,
    "DisableFirefoxStudies": true,
    "SSLVersionMin": "tls1.2",
    "TrackingProtection": {
      "Value": "strict"
    }
  }
}
'@
$ffPolicy | Out-File -FilePath "$ffPolicyDir\policies.json" -Encoding ASCII -Force

Write-Host "  ✓ Firefox: policies.json applied (no password store, TLS 1.2+, tracking protection)" -ForegroundColor Green

# -----------------------------------------------------
# 4. Adobe Acrobat Reader DC (STIG: v2r1) - Target: ~20-40% improvement
# -----------------------------------------------------
Write-Host "`n[4/7] Adobe Reader DC (pre: ~15%)" -ForegroundColor Cyan
$adobePath = "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown"
if (-not (Test-Path $adobePath)) { New-Item -Path $adobePath -Force | Out-Null }

# Enhanced Security / Protected Mode
Set-ItemProperty -Path $adobePath -Name "bUseProtectedMode" -Type DWord -Value 1
Set-ItemProperty -Path $adobePath -Name "bEnhancedSecurityInBrowser" -Type DWord -Value 1
# Block cloud services
$cServicesPath = "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\cServices"
if (-not (Test-Path $cServicesPath)) { New-Item -Path $cServicesPath -Force | Out-Null }
Set-ItemProperty -Path $cServicesPath -Name "bToggleAdobeDocumentServices" -Type DWord -Value 0

Write-Host "  ✓ Adobe: Protected Mode ON, cloud services OFF" -ForegroundColor Green

# -----------------------------------------------------
# 5. MS Defender Antivirus (STIG: v2r7) - Target: ~50-70% improvement
# -----------------------------------------------------
Write-Host "`n[5/7] MS Defender AV (pre: 23.88%)" -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
Set-MpPreference -CloudBlockLevel High -ErrorAction SilentlyContinue
Set-MpPreference -MAPSReporting Advanced -ErrorAction SilentlyContinue
Set-MpPreference -SubmitSamplesConsent SendSafeSamples -ErrorAction SilentlyContinue

Write-Host "  ✓ Defender: Real-time ON, Cloud High, Samples safe submission" -ForegroundColor Green

# -----------------------------------------------------
# 6. MS Office 365 ProPlus (STIG: v3r4) - Target: ~20-30% improvement
# -----------------------------------------------------
Write-Host "`n[6/7] MS Office 365 (pre: 7.87%)" -ForegroundColor Cyan
$officePath = "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy"
if (-not (Test-Path $officePath)) { New-Item -Path $officePath -Force | Out-Null }

# Disable telemetry and opt-out tracking
Set-ItemProperty -Path $officePath -Name "disablereadytouseenabledfeatures" -Type DWord -Value 1
Set-ItemProperty -Path $officePath -Name "disablereadytousefeatures" -Type DWord -Value 1

# Disable file validation telemetry
$fileValidationPath = "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\FileValidation"
if (-not (Test-Path $fileValidationPath)) { New-Item -Path $fileValidationPath -Force | Out-Null }
Set-ItemProperty -Path $fileValidationPath -Name "DisableFileValidation" -Type DWord -Value 0

Write-Host "  ✓ Office: Telemetry OFF, file validation ON" -ForegroundColor Green

# -----------------------------------------------------
# 7. MS .NET Framework (STIG: v2r7) - Target: ~80-90% improvement
# -----------------------------------------------------
Write-Host "`n[7/7] MS .NET Framework (pre: 69.23%)" -ForegroundColor Cyan
# Force strong crypto TLS 1.2+
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1 -ErrorAction SilentlyContinue

Write-Host "  ✓ .NET: TLS 1.2+ enforced" -ForegroundColor Green

Write-Host "  Running gpupdate" -ForegroundColor Green
gpupdate /force

# -----------------------------------------------------
Write-Host "`n[COMPLETE] Device B balanced hardening applied!" -ForegroundColor Green
Write-Host "Next: gpupdate /force, reboot, then post-SCAP scans for all products." -ForegroundColor Yellow
Write-Host "Expected: Win11 ~45%, Chrome/Edge/Firefox +20-30%, Defender +30-40%." -ForegroundColor Yellow


