<#
.SYNOPSIS
    This PowerShell script forces Windows 10 systems to use a BitLocker PIN with a minimum length of six digits for pre-boot authentication.

.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-25
    Last Modified   : 2024-12-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000032

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-00-000032.ps1
#>

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Define the registry path and values
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$ValueName = "MinimumPIN"
$ValueData = 6  # Minimum PIN length (6 or greater)

# Ensure the registry path exists
if (-not (Test-Path $RegistryPath)) {
    Write-Output "Registry path does not exist. Creating path: $RegistryPath"
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value
Write-Output "Configuring Minimum PIN length for BitLocker startup to $ValueData..."
Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -Force

# Verify the registry value
$ConfiguredValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($ConfiguredValue -ge $ValueData) {
    Write-Output "Verification successful: Minimum PIN length for BitLocker startup is set to $ConfiguredValue."
} else {
    Write-Error "Verification failed: Minimum PIN length for BitLocker startup is not configured as expected."
}

# Force Group Policy update
Write-Output "Enforcing Group Policy update..."
gpupdate /force
