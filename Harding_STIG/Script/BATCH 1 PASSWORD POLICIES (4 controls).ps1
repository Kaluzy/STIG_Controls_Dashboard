
# =====================================================================
# BATCH 1: PASSWORD POLICIES (4 controls)
# =====================================================================
Write-Host "`n[BATCH 1] Applying Password Policies..." -ForegroundColor Cyan

# V-253300: Password history 24
Write-Host "  [V-253300] Setting password history to 24..." -ForegroundColor Yellow
net accounts /UNIQUEPW:24
$ph = (net accounts | Select-String "Password history").ToString()
Write-Host "    ✓ Result: $ph" -ForegroundColor Green

# V-253301: Max password age 60 days
Write-Host "  [V-253301] Setting max password age to 60 days..." -ForegroundColor Yellow
net accounts /maxpwage:60
$mpa = (net accounts | Select-String "Maximum password").ToString()
Write-Host "    ✓ Result: $mpa" -ForegroundColor Green

# V-253302: Min password age 1 day
Write-Host "  [V-253302] Setting min password age to 1 day..." -ForegroundColor Yellow
net accounts /minpwage:1
$minpa = (net accounts | Select-String "Minimum password age").ToString()
Write-Host "    ✓ Result: $minpa" -ForegroundColor Green

# V-253303: Min password length 14
Write-Host "  [V-253303] Setting min password length to 14 characters..." -ForegroundColor Yellow
set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "MinimumPasswordLength" -Value 14 -Type DWord
$len = (net accounts | Select-String "Minimum password length").ToString()
Write-Host "    ✓ Result: $len" -ForegroundColor Green

# =====================================================================
# BATCH 1: ACCOUNT LOCKOUT POLICIES (2 controls)
# =====================================================================
Write-Host "`n[BATCH 1] Applying Account Lockout Policies..." -ForegroundColor Cyan

# V-253297: Account lockout threshold (5 invalid attempts)
Write-Host "  [V-253297] Setting account lockout threshold to 5 invalid attempts..." -ForegroundColor Yellow
net accounts /lockoutthreshold:5
$threshold = (net accounts | Select-String "Lockout threshold").ToString()
Write-Host "    ✓ Result: $threshold" -ForegroundColor Green

# V-253297 (continued): Account lockout duration (15 minutes)
Write-Host "  [V-253297] Setting account lockout duration to 15 minutes..." -ForegroundColor Yellow
net accounts /lockoutduration:15
$duration = (net accounts | Select-String "Lockout duration").ToString()
Write-Host "    ✓ Result: $duration" -ForegroundColor Green

# V-253299: Reset account lockout counter after (15 minutes)
Write-Host "  [V-253299] Setting reset account lockout counter after to 15 minutes..." -ForegroundColor Yellow
net accounts /lockoutwindow:15
$window = (net accounts | Select-String "Lockout observation window").ToString()
Write-Host "    ✓ Result: $window" -ForegroundColor Green

Write-Host "`n[BATCH 1] Account Lockout Policies Applied" -ForegroundColor Green
Write-Host "⚠️  NOTE: These are local settings and will revert after 'gpupdate /force' or reboot." -ForegroundColor Yellow
Write-Host "          Apply at domain level via Active Directory Group Policy for persistence." -ForegroundColor Yellow

<#
Verify GPO Effective Settings

Run on pilot: gpresult /h C:\temp\gpo.html /scope computer → Check Password Policy section (domain wins). Re-scan post-domain change.
#>