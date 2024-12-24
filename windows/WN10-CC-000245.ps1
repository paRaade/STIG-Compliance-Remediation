<#
.SYNOPSIS
    This PowerShell script disables the Microsoft Edge password manager 

.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-24
    Last Modified   : 2024-12-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000245

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-CC-000245.ps1
#>

# Define registry details
$RegistryHive = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main"
$ValueName = "FormSuggest Passwords"
$ValueType = "String"
$ValueData = "no"

# Check if the registry path exists
if (-not (Test-Path $RegistryHive)) {
    Write-Output "Registry path does not exist. Creating path: $RegistryHive"
    New-Item -Path $RegistryHive -Force | Out-Null
}

# Check if the registry value exists and is configured correctly
$CurrentValue = (Get-ItemProperty -Path $RegistryHive -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($CurrentValue -ne $ValueData) {
    Write-Output "Configuring registry value: $ValueName"
    Set-ItemProperty -Path $RegistryHive -Name $ValueName -Value $ValueData -Force
    Write-Output "Registry value configured successfully: $ValueName = $ValueData"
} else {
    Write-Output "Registry value is already configured correctly: $ValueName = $ValueData"
}

# Verify the configuration
$ConfiguredValue = (Get-ItemProperty -Path $RegistryHive -Name $ValueName -ErrorAction SilentlyContinue).$ValueName
if ($ConfiguredValue -eq $ValueData) {
    Write-Output "Verification successful: Registry value is configured correctly."
} else {
    Write-Output "Verification failed: Registry value is not configured as expected."
}
