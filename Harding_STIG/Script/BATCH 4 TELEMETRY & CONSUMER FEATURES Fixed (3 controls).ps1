# =====================================================================
# BATCH 4 FIX: Corrected registry paths from STIG check content
# =====================================================================
Write-Host "`n[BATCH 4 FIX] Applying corrected Telemetry & Consumer controls..." -ForegroundColor Cyan

try {
    # V-253390: DisableWindowsConsumerFeatures = 1
    # STIG Check: HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent
    Write-Host "  [V-253390] Disabling Microsoft Consumer Experiences..." -ForegroundColor Yellow
    $cloudPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    if (-not (Test-Path $cloudPath)) { New-Item -Path $cloudPath -Force | Out-Null }
    Set-ItemProperty -Path $cloudPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord -Force
    $v253390 = (Get-ItemProperty -Path $cloudPath -Name "DisableWindowsConsumerFeatures").DisableWindowsConsumerFeatures
    Write-Host "    ✓ DisableWindowsConsumerFeatures = $v253390 (expected: 1)" -ForegroundColor Green

    # V-253393: AllowTelemetry = 0 or 1 (Security or Basic)
    # STIG Check: HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection
    Write-Host "  [V-253393] Setting Telemetry to Basic/Security level..." -ForegroundColor Yellow
    $telPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $telPath)) { New-Item -Path $telPath -Force | Out-Null }
    Set-ItemProperty -Path $telPath -Name "AllowTelemetry" -Value 1 -Type DWord -Force
    $v253393 = (Get-ItemProperty -Path $telPath -Name "AllowTelemetry").AllowTelemetry
    Write-Host "    ✓ AllowTelemetry = $v253393 (expected: 0 or 1)" -ForegroundColor Green

    # V-253392: LimitEnhancedDiagnosticDataWindowsAnalytics = 1
    # STIG Check: HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection
    Write-Host "  [V-253392] Limiting Enhanced Diagnostic Data..." -ForegroundColor Yellow
    Set-ItemProperty -Path $telPath -Name "LimitEnhancedDiagnosticDataWindowsAnalytics" -Value 1 -Type DWord -Force
    $v253392 = (Get-ItemProperty -Path $telPath -Name "LimitEnhancedDiagnosticDataWindowsAnalytics").LimitEnhancedDiagnosticDataWindowsAnalytics
    Write-Host "    ✓ LimitEnhancedDiagnosticDataWindowsAnalytics = $v253392 (expected: 1)" -ForegroundColor Green

    # V-253384: DisableSearchBoxSuggestions = 1
    # STIG Check: HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer
    Write-Host "  [V-253384] Disabling Search Box Suggestions..." -ForegroundColor Yellow
    $explorerPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (-not (Test-Path $explorerPath)) { New-Item -Path $explorerPath -Force | Out-Null }
    Set-ItemProperty -Path $explorerPath -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -Force
    $v253384 = (Get-ItemProperty -Path $explorerPath -Name "DisableSearchBoxSuggestions").DisableSearchBoxSuggestions
    Write-Host "    ✓ DisableSearchBoxSuggestions = $v253384 (expected: 1)" -ForegroundColor Green

    # V-253425: NOTE - this is NOT Task View. Check what V-253425 actually maps to
    # V-253425 = Application Compatibility Inventory Collector disabled
    # STIG Check: HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat\DisableInventory = 1
    Write-Host "  [V-253425] Disabling App Compatibility Inventory..." -ForegroundColor Yellow
    $appCompatPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
    if (-not (Test-Path $appCompatPath)) { New-Item -Path $appCompatPath -Force | Out-Null }
    Set-ItemProperty -Path $appCompatPath -Name "DisableInventory" -Value 1 -Type DWord -Force
    $v253425 = (Get-ItemProperty -Path $appCompatPath -Name "DisableInventory").DisableInventory
    Write-Host "    ✓ DisableInventory = $v253425 (expected: 1)" -ForegroundColor Green

    Write-Host "`n[BATCH 4 FIX] ✓ All 5 controls applied" -ForegroundColor Green
    Write-Host "  ⚠️  Run: gpupdate /force then re-scan SCC" -ForegroundColor Yellow

} catch {
    Write-Host "  ❌ ERROR: $_" -ForegroundColor Red
}
