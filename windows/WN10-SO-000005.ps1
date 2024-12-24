<#
.SYNOPSIS
    This PowerShell script disables the built-in administrator account 

.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-24
    Last Modified   : 2024-12-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000005

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-SO-000005.ps1
#>

# Define the registry path and value for disabling the Administrator account
$RegistryHive = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$ValueName = "EnableAdminAccount"
$ValueData = 0  # 0 = Disabled, 1 = Enabled

# Check if the registry path exists
if (-not (Test-Path $RegistryHive)) {
    Write-Output "Registry path does not exist. Creating path: $RegistryHive"
    New-Item -Path $RegistryHive -Force | Out-Null
}

# Check the current value of the Administrator account status
$CurrentValue = (Get-ItemProperty -Path $RegistryHive -Name $ValueName -ErrorAction SilentlyContinue).$ValueName

if ($CurrentValue -ne $ValueData) {
    Write-Output "Disabling the built-in Administrator account..."
    Set-ItemProperty -Path $RegistryHive -Name $ValueName -Value $ValueData -Force
    Write-Output "The built-in Administrator account has been disabled."
} else {
    Write-Output "The built-in Administrator account is already disabled."
}

# Verify the change
$ConfiguredValue = (Get-ItemProperty -Path $RegistryHive -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($ConfiguredValue -eq $ValueData) {
    Write-Output "Verification successful: Administrator account is disabled."
} else {
    Write-Output "Verification failed: Administrator account is not disabled as expected."
}

# Additional step to disable the account directly (if needed)
Write-Output "Disabling the Administrator account at the system level..."
Disable-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue
if ((Get-LocalUser -Name "Administrator").Enabled -eq $false) {
    Write-Output "The built-in Administrator account has been successfully disabled at the system level."
} else {
    Write-Output "Failed to disable the Administrator account at the system level."
}
