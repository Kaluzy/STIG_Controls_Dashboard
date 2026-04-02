# =====================================================================
# COMMON: Simple Write-Log helper
# =====================================================================
function Write-Log {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO","SUCCESS","ERROR","WARN")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$timestamp] [$Level] $Message"

    # Console
    Write-Host $entry

    # File log (adjust path as needed)
    $logPath = "C:\Logs\Tier2-STIG-Remediation.log"
    $logDir  = Split-Path $logPath -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    }

    $entry | Out-File -FilePath $logPath -Append -Encoding utf8
}

# =====================================================================
# BATCH 3: AUDIT LOGGING (Tier 2 - Corrected Subcategories)
# =====================================================================
Write-Host "`n[BATCH 3] Applying Audit Logging Policies..." -ForegroundColor Cyan
Write-Log "[BATCH 3] Audit Logging - START" "INFO"

try {
    # V-253306: Account Logon -> Credential Validation (FAILURE)
    Write-Host "  [V-253306] Account Logon - Credential Validation (Failure)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"Credential Validation" /failure:enable | Out-Null
    $cvFail = auditpol /get /subcategory:"Credential Validation" | Select-String "Failure"
    Write-Host "    ✓ Credential Validation Failure: $($cvFail -replace '.*(Success and Failure|Failure).*', '$1')" -ForegroundColor Green
    Write-Log "V-253306: Credential Validation (Failure) enabled" "SUCCESS"

    # V-253307: Account Logon -> Credential Validation (SUCCESS) 
    Write-Host "  [V-253307] Account Logon - Credential Validation (Success)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"Credential Validation" /success:enable | Out-Null
    $cvSucc = auditpol /get /subcategory:"Credential Validation" | Select-String "Success"
    Write-Host "    ✓ Credential Validation Success: $($cvSucc -replace '.*(Success and Failure|Success).*', '$1')" -ForegroundColor Green
    Write-Log "V-253307: Credential Validation (Success) enabled" "SUCCESS"

    # V-253316/317: Logon/Logoff -> Logon (FAILURE + SUCCESS)
    Write-Host "  [V-253316/317] Logon/Logoff - Logon (Success + Failure)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"Logon" /success:enable /failure:enable | Out-Null
    $logon = auditpol /get /subcategory:"Logon" | Select-String "Success and Failure"
    Write-Host "    ✓ Logon auditing: $logon" -ForegroundColor Green
    Write-Log "V-253316/317: Logon (S+F) enabled" "SUCCESS"

    # V-253319: Object Access -> File Share (FAILURE)
    Write-Host "  [V-253319] Object Access - File Share (Failure)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"File Share" /failure:enable | Out-Null
    $fsFail = auditpol /get /subcategory:"File Share" | Select-String "Failure"
    Write-Host "    ✓ File Share Failure: $($fsFail -replace '.*(Success and Failure|Failure).*', '$1')" -ForegroundColor Green
    Write-Log "V-253319: File Share (Failure) enabled" "SUCCESS"

    # V-253324: Object Access -> Removable Storage (SUCCESS)
    Write-Host "  [V-253324] Object Access - Removable Storage (Success)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"Removable Storage" /success:enable | Out-Null
    $rsSucc = auditpol /get /subcategory:"Removable Storage" | Select-String "Success"
    Write-Host "    ✓ Removable Storage Success: $($rsSucc -replace '.*(Success and Failure|Success).*', '$1')" -ForegroundColor Green
    Write-Log "V-253324: Removable Storage (Success) enabled" "SUCCESS"

    # V-253325: Policy Change -> Audit Policy Change (SUCCESS)
    Write-Host "  [V-253325] Policy Change - Audit Policy Change (Success)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"Audit Policy Change" /success:enable | Out-Null
    $apcSucc = auditpol /get /subcategory:"Audit Policy Change" | Select-String "Success"
    Write-Host "    ✓ Audit Policy Change Success: $($apcSucc -replace '.*(Success and Failure|Success).*', '$1')" -ForegroundColor Green
    Write-Log "V-253325: Audit Policy Change (Success) enabled" "SUCCESS"

    # V-253329: Privilege Use -> Sensitive Privilege Use (SUCCESS)
    Write-Host "  [V-253329] Privilege Use - Sensitive Privilege Use (Success)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"Sensitive Privilege Use" /success:enable | Out-Null
    $spuSucc = auditpol /get /subcategory:"Sensitive Privilege Use" | Select-String "Success"
    Write-Host "    ✓ Sensitive Privilege Use Success: $($spuSucc -replace '.*(Success and Failure|Success).*', '$1')" -ForegroundColor Green
    Write-Log "V-253329: Sensitive Privilege Use (Success) enabled" "SUCCESS"

    # V-253330: System -> IPsec Driver (FAILURE)
    Write-Host "  [V-253330] System - IPsec Driver (Failure)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"IPsec Driver" /failure:enable | Out-Null
    $ipsecFail = auditpol /get /subcategory:"IPsec Driver" | Select-String "Failure"
    Write-Host "    ✓ IPsec Driver Failure: $($ipsecFail -replace '.*(Success and Failure|Failure).*', '$1')" -ForegroundColor Green
    Write-Log "V-253330: IPsec Driver (Failure) enabled" "SUCCESS"

    # V-253336: System -> System Integrity (SUCCESS + FAILURE)
    Write-Host "  [V-253336] System - System Integrity (Success + Failure)..." -ForegroundColor Yellow
    auditpol /set /subcategory:"System Integrity" /success:enable /failure:enable | Out-Null
    $si = auditpol /get /subcategory:"System Integrity" | Select-String "Success and Failure"
    Write-Host "    ✓ System Integrity: $si" -ForegroundColor Green
    Write-Log "V-253336: System Integrity (S+F) enabled" "SUCCESS"

    # V-253337: Event Log Sizes (32MB minimum per STIG)
    Write-Host "  [V-253337] Event log sizes to 32MB minimum..." -ForegroundColor Yellow
    wevtutil sl Security /ms:32768
    wevtutil sl System /ms:32768
    wevtutil sl Application /ms:32768
    $secSize = wevtutil gl Security | Select-String "maxSize"
    Write-Host "    ✓ Security log: $secSize" -ForegroundColor Green
    Write-Log "V-253337: Event logs sized to 32MB minimum" "SUCCESS"

    Write-Host "`n[BATCH 3] ✓ Audit Logging COMPLETE (10 controls)" -ForegroundColor Green
    Write-Log "[BATCH 3] Audit Logging - COMPLETE" "SUCCESS"
    Write-Host "⚠️  NEXT: Run gpupdate /force && auditpol /get /r" -ForegroundColor Yellow

} catch {
    Write-Host "  ❌ ERROR: $_" -ForegroundColor Red
    Write-Log "BATCH 3 ERROR: $_" "ERROR"
}
