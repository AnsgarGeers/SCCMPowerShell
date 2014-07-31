# ---------------------------------------------------
# Version: 1.0
# Author: Joshua Duffney
# Date: 07/31/2014
# Description: Pulls ApplicationName and Collection name from a .csv file to remove\stop the application deployment.
# Comments: Refer to the RemoveCMApplication.csv file for a template. Run the SCCM report Software Distribtuion > Application Monitoring > All application deployments (advanced) to get a list of application names and collections they are deployed to.
# ---------------------------------------------------

Function RemoveCMDeployments {

    Param(
    [string]$SiteServerName,
    [string]$SiteCode,
    [string]$csvPath
)
   
   ## Import SCCM Console Module
    Try
    {
    Import-Module "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1" -ErrorAction Stop
    Set-Location "$($SiteCode):"
    }
    Catch [System.IO.FileNotFoundException]
    {
        "SCCM Admin Console not installed"
    }
    Catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
    }
    Finally
    {
        "This Script attempted to import the SCCM module"
    }
    
    $pkgs = Import-Csv "$csvPath"

    $ApplicationName = $pkg.ApplicationName    

    foreach($pkg in $pkgs){
        Try{
        Remove-CMDeployment -ApplicationName $pkg.ApplicationName -CollectionName $pkg.CollectionName -Force -ErrorAction Stop | Out-Null
        Write-Host "$ApplicationName was removed" -ForegroundColor Green
        }
        Catch
        {
        }
    }

}

RemoveCMDeployments -SiteServerName ServerName -SiteCode SiteCode -csvPath "C:\scripts\RemoveCMApplication.csv"
