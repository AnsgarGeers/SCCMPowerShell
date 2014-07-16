# ---------------------------------------------------
# Version: 2.0
# Author: Joshua Duffney
# Date: 07/15/2014
# Description: Using PowerShell to check for a list of devices in SCCM and AD then returning the results in a table format.
# Comments: Populate computers.txt with a list of computer names then run the script.
# ---------------------------------------------------


## Connect to SCCM
    $ErrorActionPreference = "stop"
    $SiteServerName = 'ServerName'
    $SiteCode = 'SiteCode'

    if (!(Test-Path "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1")) {
        Write-Error 'Configuration Manager module not found. Is the admin console installed?'
        } elseif (!(Get-Module 'ConfigurationManager')) {
            Import-Module "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1"
        }
        Set-Location "$($SiteCode):"

## Looking for device in SCCM
foreach ($computer in (Get-Content "D:\Scripts\computers.txt")) 
{
$value = Get-CMDevice -Name $computer
if ($value -eq $null){$Results = "NO"}
else{$Results = "Yes"}

 try {
    Get-ADComputer $computer -ErrorAction Stop | Out-Null
    $computerResults = $true
}
Catch {
    $computerResults = $false

}

[PSCustomObject]@{
        Name = $computer
        SCCM = $Results
        AD = $computerResults
        }

}
