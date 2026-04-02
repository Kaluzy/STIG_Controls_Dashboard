# =====================================================================
# BATCH 5: CONSUMER UX & RDP HARDENING (V-253390/425/384, V-253405/406, V-253402/404)
# =====================================================================
Write-Host "`n[BATCH X] Applying consumer UX & RDP hardening..." -ForegroundColor Cyan

try {
    # ---------------------------------------------------------------
    # V-253390, V-253425, V-253384
    # Disable Microsoft consumer experiences & suggestions
    # ---------------------------------------------------------------
    Write-Host "  [V-253390/425/384] Disabling consumer experiences & suggestions..." -ForegroundColor Yellow

    $cloudContentPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    if (-not (Test-Path $cloudContentPath)) {
        New-Item -Path $cloudContentPath -Force | Out-Null
    }

    # Turn off Microsoft consumer experiences
    Set-ItemProperty -Path $cloudContentPath -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1 -Force
    # Turn off third party suggestions
    Set-ItemProperty -Path $cloudContentPath -Name "DisableThirdPartySuggestions" -Type DWord -Value 1 -Force

    $ccValues = Get-ItemProperty -Path $cloudContentPath -ErrorAction SilentlyContinue
    Write-Host "    ✓ DisableWindowsConsumerFeatures = $($ccValues.DisableWindowsConsumerFeatures)" -ForegroundColor Green
    Write-Host "    ✓ DisableThirdPartySuggestions  = $($ccValues.DisableThirdPartySuggestions)"  -ForegroundColor Green

    # Optional: disable Start menu search box suggestions if you want to align with V-253384 style behavior
    $explorerPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (-not (Test-Path $explorerPath)) {
        New-Item -Path $explorerPath -Force | Out-Null
    }
    Set-ItemProperty -Path $explorerPath -Name "DisableSearchBoxSuggestions" -Type DWord -Value 1 -Force
    $expValues = Get-ItemProperty -Path $explorerPath -ErrorAction SilentlyContinue
    Write-Host "    ✓ DisableSearchBoxSuggestions  = $($expValues.DisableSearchBoxSuggestions)" -ForegroundColor Green

    # ---------------------------------------------------------------
    # V-253405, V-253406
    # Harden RDP & RPC (secure RPC + High encryption)
    # ---------------------------------------------------------------
    Write-Host "  [V-253405/406] Hardening RDP & RPC..." -ForegroundColor Yellow

    $tsPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
    if (-not (Test-Path $tsPath)) {
        New-Item -Path $tsPath -Force | Out-Null
    }

    # Require secure RPC communication
    Set-ItemProperty -Path $tsPath -Name "fEncryptRPCTraffic" -Type DWord -Value 1 -Force
    # Set client connection encryption level to High (3)
    Set-ItemProperty -Path $tsPath -Name "MinEncryptionLevel" -Type DWord -Value 3 -Force

    $tsValues = Get-ItemProperty -Path $tsPath -ErrorAction SilentlyContinue
    Write-Host "    ✓ fEncryptRPCTraffic = $($tsValues.fEncryptRPCTraffic) (1 = required)" -ForegroundColor Green
    Write-Host "    ✓ MinEncryptionLevel = $($tsValues.MinEncryptionLevel) (3 = High)" -ForegroundColor Green

    # ---------------------------------------------------------------
    # V-253402, V-253404
    # Block saved RDP credentials & drive mapping
    # ---------------------------------------------------------------
    Write-Host "  [V-253402/404] Blocking saved RDP creds & drive mapping..." -ForegroundColor Yellow

    # Do not allow passwords to be saved
    Set-ItemProperty -Path $tsPath -Name "DisablePasswordSaving" -Type DWord -Value 1 -Force
    # Do not allow drive redirection
    Set-ItemProperty -Path $tsPath -Name "fDisableCdm" -Type DWord -Value 1 -Force

    $tsValues2 = Get-ItemProperty -Path $tsPath -ErrorAction SilentlyContinue
    Write-Host "    ✓ DisablePasswordSaving = $($tsValues2.DisablePasswordSaving) (1 = block saved creds)" -ForegroundColor Green
    Write-Host "    ✓ fDisableCdm          = $($tsValues2.fDisableCdm) (1 = block drive mapping)" -ForegroundColor Green

    Write-Host "`n[BATCH X] ✓ Consumer UX & RDP controls applied" -ForegroundColor Green
    Write-Host "   Next: gpupdate /force and re-run SCC scan for V-253390/425/384, V-253405/406, V-253402/404." -ForegroundColor Yellow

} catch {
    Write-Host "  ❌ ERROR in BATCH X: $_" -ForegroundColor Red
}
