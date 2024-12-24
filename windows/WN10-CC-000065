<#
.SYNOPSIS
    This PowerShell script disables Wi-Fi Sense

.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-24
    Last Modified   : 2024-12-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000065

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-CC-000065.ps1
#>

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Define the registry path and value
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
$ValueName = "AutoConnectAllowedOEM"
$ValueData = 0  # 0 = Disabled

# Ensure the registry path exists
if (-not (Test-Path $RegistryPath)) {
    Write-Output "Registry path does not exist. Creating path: $RegistryPath"
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value
Write-Output "Disabling Wi-Fi Sense by setting AutoConnectAllowedOEM to 0..."
Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -Force

# Verify the registry value
$ConfiguredValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($ConfiguredValue -eq $ValueData) {
    Write-Output "Verification successful: Wi-Fi Sense is disabled (AutoConnectAllowedOEM is set to 0)."
} else {
    Write-Error "Verification failed: AutoConnectAllowedOEM is not configured as expected."
}

# Force Group Policy update
Write-Output "Enforcing Group Policy update..."
gpupdate /force

