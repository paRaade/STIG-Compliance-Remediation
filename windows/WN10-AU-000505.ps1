<#
.SYNOPSIS
    This PowerShell script configures the security event log size to be configured to 1024000 KB 

.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-24
    Last Modified   : 2024-12-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000505

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-AU-000505.ps1
#>

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Define the registry path and values
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
$ValueName = "MaxSize"
$ValueData = 1024000  # 1,024,000 KB

# Ensure the registry path exists
if (-not (Test-Path $RegistryPath)) {
    Write-Output "Registry path does not exist. Creating path: $RegistryPath"
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value
Write-Output "Configuring Security event log size to $ValueData KB..."
Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -Force

# Verify the registry value
$ConfiguredValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($ConfiguredValue -ge $ValueData) {
    Write-Output "Verification successful: Security event log size is set to $ConfiguredValue KB."
} else {
    Write-Error "Verification failed: Security event log size is not configured as expected."
}

# Force Group Policy update
Write-Output "Enforcing Group Policy update..."
gpupdate /force

