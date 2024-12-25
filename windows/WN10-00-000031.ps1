<#
.SYNOPSIS
    This PowerShell script forces Windows 10 to use a BitLocker PIN for pre-boot authentication.
    
.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-25
    Last Modified   : 2024-12-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000031

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-00-000031.ps1
#>

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Define the registry path
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"

# Define the required registry values and their configurations
$RegistryValues = @{
    "UseAdvancedStartup" = 1;
    "UseTPMPIN" = 1;
    "UseTPMKeyPIN" = 1
}

# Ensure the registry path exists
if (-not (Test-Path $RegistryPath)) {
    Write-Output "Registry path does not exist. Creating path: $RegistryPath"
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the required registry values
foreach ($Key in $RegistryValues.Keys) {
    $Value = $RegistryValues[$Key]
    Write-Output "Configuring $Key to $Value..."
    Set-ItemProperty -Path $RegistryPath -Name $Key -Value $Value -Force
}

# Verify the configured registry values
Write-Output "Verifying the configured registry values..."
foreach ($Key in $RegistryValues.Keys) {
    $ExpectedValue = $RegistryValues[$Key]
    $ConfiguredValue = (Get-ItemProperty -Path $RegistryPath -Name $Key -ErrorAction SilentlyContinue).$Key
    if ($ConfiguredValue -eq $ExpectedValue) {
        Write-Output "Verification successful: $Key is set to $ConfiguredValue."
    } else {
        Write-Error "Verification failed: $Key is not set correctly. Current value: $ConfiguredValue."
    }
}

# Force Group Policy update
Write-Output "Enforcing Group Policy update..."
gpupdate /force

