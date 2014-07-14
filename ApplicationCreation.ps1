# ---------------------------------------------------
# Version: .2
# Author: Joshua Duffney
# Date: 07/11/2014
# Description: Using PowerShell to create an SCCM Application from information in a .csv file.
# Comments: Refer to ApplicationCreation.csv in the repo to complete the script.
# Sources: Some code from @adbertram at Pluralsight Course Planning & Creating Applications in System Center ConfigMgr 2012 http://pluralsight.com/training/courses/TableOfContents?courseName=planning-creating-applications-sccm-2012&highlight
# ---------------------------------------------------


$pkgs = Import-Csv "C:\scripts\CreateApplication.csv"
    foreach($pkg in $pkgs)
    {
    ## Create & Copy Source files
    $ErrorActionPreference = "stop"
    $SiteServerName = 'ServerName'
    $SiteCode = 'SiteCode'
    $SharedContentFolder = $pkg.SharedContentFolder
    $SourceFolderPath = $pkg.SourceFolderPath
    $Publisher = $pkg.Publisher
    $ApplicationName = $pkg.Name
    $Version = $pkg.SoftwareVersion

    if (!(Test-Path "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1")) {
        Write-Error 'Configuration Manager module not found. Is the admin console installed?'
        } elseif (!(Get-Module 'ConfigurationManager')) {
            Import-Module "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1"
        }
        Set-Location "$($SiteCode):"


        if (Get-CMApplication -Name $ApplicationName) {
            Write-Error "The application $ApplicationName already exists."
        }
       

        ## Create the shared content folder for the application
        ## Replace any spaces with Underscores to simplify file system navigation
        $ApplicationSourceContent = "$($Publisher)_$($ApplicationName)_$($Version)".Replace(' ','_')
        $ApplicationSourceContent = "$SharedContentFolder\$ApplicationSourceContent"
        if (!(Test-Path $ApplicationSourceContent)) {
            Set-Location $env:SystemRoot
            mkdir $ApplicationSourceContent | Out-Null
        } else {
            Write-Warning "The path $ApplicationSourceContent already exists"
        }
        Copy-Item $SourceFolderPath\* $ApplicationSourceContent -Recurse -Force
        Write-Host -ForegroundColor green "$ApplicationName directory created"

     ## Create the application container. This will hold our deployment type.
        $NewCmApplicationParams = @{
        'Name'= $pkg.Name + $pkg.SoftwareVersion;
        'Owner' = $pkg.Owner;
        'SupportContact' = $pkg.SupportContact;
        'IconLocationFile' = $ApplicationSourceContent+ '\' + $ApplicationName + '.ico';
        'Publisher' = $pkg.Publisher;
        'SoftwareVersion' = $pkg.SoftwareVersion;
        }
        Set-Location "$($SiteCode):"
        New-CMApplication @NewCmApplicationParams | Out-Null

    
     ## Create the deployment type.
        $AddCMDeploymentTypeParams = @{
        'ApplicationName' = $pkg.Name + $pkg.SoftwareVersion;
        'DeploymentTypeName' = $pkg.DeploymentTypeName;
        'ScriptInstaller' = $true;
        'ManualSpecifyDeploymentType' = $true;
        'InstallationProgram' = $pkg.InstallationProgram;
        'ContentLocation' = $ApplicationSourceContent;
        'InstallationBehaviorType' = $pkg.InstallationBehaviorType;
        'InstallationProgramVisibility' = $pkg.InstallationProgramVisibility;
        'MaximumAllowedRunTimeMinutes' = $pkg.MaximumAllowedRunTimeMinutes;
        'EstimatedInstallationTimeMinutes' = $pkg.EstimatedInstallationTimeMinutes;
        'DetectDeploymentTypeByCustomScript' = $true;
        'ScriptType' = $pkg.ScriptType;
        'ScriptContent' = $pkg.ScriptContent;
        }
        Add-CMDeploymentType @AddCMDeploymentTypeParams | Out-Null

    ## Create SCCM Vendor Folder and Move New Application
       $ApplicationName = $pkg.Name+$pkg.SoftwareVersion
       $Application = Get-CMApplication -Name $ApplicationName
       $ApplicationFolder = $pkg.Publisher
       $VendorFolders = (get-childitem).Name
       
       #Checks for existing Vendor Folder
       Set-Location .\Application
       if ($VendorFolders -eq $ApplicationFolder) {
            Move-CMObject -FolderPath $ApplicationFolder -InputObject $Application -Verbose
       } else {
            New-Item -Name $ApplicationFolder
            Move-CMObject -FolderPath $ApplicationFolder -InputObject $Application -Verbose
       }
       
    ## Set DistributionPointSettings
       $AppliactionID = (Get-CMApplication -name $ApplicationName).CI_ID
       Set-CMApplication -Id $AppliactionID -DistributionPointSetting $pkg.DistributionPointSetting

   ## Set CatalogCategory
      #New-CMCategory -CategoryType CatalogCategories -Name $pkg.CatalogCategory
      Set-CMApplication -Id $AppliactionID -UserCategories $pkg.CatalogCategory
}
