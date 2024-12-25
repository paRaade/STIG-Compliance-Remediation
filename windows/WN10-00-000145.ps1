<#
.SYNOPSIS
    This PowerShell script configures the application event log size to be 32,768 KB

.NOTES
    Author          : Sameal Con-Roma
    LinkedIn        : linkedin.com/in/sameal/
    GitHub          : paraade.github.io
    Date Created    : 2024-12-24
    Last Modified   : 2024-12-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000145

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\WN10-00-000145.ps1
#>

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires administrative privileges. Please run PowerShell as an administrator."
    exit
}

# Function to check DEP configuration
function Check-DEP {
    Write-Output "Checking DEP configuration..."
    $DEPStatus = bcdedit /enum '{current}' | Select-String -Pattern "nx\s+\S+"
    if ($DEPStatus -match "nx\s+OptOut") {
        Write-Output "DEP is configured as OptOut. No changes needed."
    } elseif ($DEPStatus -match "nx\s+AlwaysOn") {
        Write-Output "DEP is configured as AlwaysOn. This is acceptable and more restrictive."
    } else {
        Write-Output "DEP is not configured as OptOut or AlwaysOn. This is a finding."
    }
}

# Function to configure DEP to OptOut
function Configure-DEP {
    Write-Output "Configuring DEP to OptOut..."
    try {
        bcdedit /set '{current}' nx OptOut
        Write-Output "DEP successfully configured to OptOut. Restart the system for changes to take effect."
    } catch {
        Write-Error "Failed to configure DEP. Error: $_"
    }
}

# Main script logic
Check-DEP

Write-Output "Do you want to configure DEP to OptOut? (Y/N)"
$UserInput = Read-Host

if ($UserInput -match "^[Yy]$") {
    Configure-DEP
} else {
    Write-Output "No changes made to DEP configuration."
}


Write-Output "Enforcing Group Policy update..."
gpupdate /force
