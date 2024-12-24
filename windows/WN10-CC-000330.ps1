<#
.SYNOPSIS
    This PowerShell script prevents the Windows Remote Management (WinRM) client from using Basic authentication

.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-24
    Last Modified   : 2024-12-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000330

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-CC-000330.ps1
#>

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Define the registry path and values
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
$ValueName = "AllowBasic"
$ValueData = 0  # 0 = Disabled

# Ensure the registry path exists
if (-not (Test-Path $RegistryPath)) {
    Write-Output "Registry path does not exist. Creating path: $RegistryPath"
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value
Write-Output "Disabling Basic authentication for the WinRM Client..."
Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -Force

# Verify the registry value
$ConfiguredValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($ConfiguredValue -eq $ValueData) {
    Write-Output "Verification successful: Basic authentication is disabled for the WinRM Client."
} else {
    Write-Error "Verification failed: Basic authentication is not configured as expected."
}

# Force Group Policy update
Write-Output "Enforcing Group Policy update..."
gpupdate /force
