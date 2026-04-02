
# =====================================================================
# BATCH 2: BITLOCKER & HARDWARE SECURITY (4 controls)
# =====================================================================
Write-Host "`n[BATCH 2] Applying BitLocker & Hardware Security..." -ForegroundColor Cyan

# V-253259: BitLocker baseline (OS disk) // It is on CAT1
Write-Host "  [V-253259] Enabling BitLocker on C: drive..." -ForegroundColor Yellow
try {
    $bitlockerStatus = Get-BitLockerVolume -MountPoint C: -ErrorAction Stop
    if ($bitlockerStatus.ProtectionStatus -ne 1) {
        Enable-BitLocker -MountPoint C: -TpmProtector -RecoveryPasswordProtector -SkipHardwareTest
        Write-Host "    OK: BitLocker enabled with TPM and recovery key" -ForegroundColor Green
    } else {
        Write-Host "    INFO: BitLocker already enabled on C:" -ForegroundColor Yellow
    }
} catch {
    Write-Host "    ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
#Validate with to check protection status is ON
#Get-BitLockerVolume -MountPoint 'C:'

# V-253370: Credential Guard (VBS) / it is on cat 1 and it alread passed why is it in here.
Write-Host "  [V-253370] Enabling Credential Guard..." -ForegroundColor Yellow
$credGuardPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
New-Item -Path $credGuardPath -Force | Out-Null
Set-ItemProperty -Path $credGuardPath -Name EnableVirtualizationBasedSecurity -Value 1 -Type DWord -Force
Write-Host "    OK: Credential Guard enabled" -ForegroundColor Green

# V-253371: VBS / HVCI / Already Passed the Stig on first scan / why is in here
Write-Host "  [V-253371] Enabling VBS / HVCI..." -ForegroundColor Yellow
$hvciPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
New-Item -Path $hvciPath -Force | Out-Null
Set-ItemProperty -Path $hvciPath -Name Enabled -Value 1 -Type DWord -Force
Write-Host "    OK: HVCI enabled" -ForegroundColor Green

<#
# V-253426: IOMMU / DMA protection
Write-Host "  [V-253426] Enabling IOMMU / DMA protection..." -ForegroundColor Yellow
Set-ItemProperty -Path $credGuardPath -Name IommuPolicy -Value 1 -Type DWord -Force
Write-Host "    OK: IOMMU policy enabled" -ForegroundColor Green

#>

# V-253426 IOMMU / DMA protection – Kernel DMA Protection (Block All)

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"

if (-not (Test-Path $path)) {
    New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "DeviceEnumerationPolicy" -Value 0 -Type DWord -Force

#Verification for V-d253426
(Get-ItemPropertyValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection" DeviceEnumerationPolicy -ErrorAction SilentlyContinue)