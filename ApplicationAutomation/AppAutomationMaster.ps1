$Global:App = New-Object -Type PSObject -Property (            
  @{            

<#----------- Input Variables -------------#>
   "Vendor" = 'CreativeCloud'
   "Name"  = 'ProductionPremiumSuite'
   "Version" = 'CS4'
   "InstallString" = '/qn'
   "InstallStringx64" = ''
   "InstallFile" = 'Creative Cloud Production Premium Suite x64.msi' #Separate with "," for multiple files
   "InstallFilex64" = '' #Separate with "," for multiple files
   "PreInstall_CloseApps" = 'InCopy.exe'
   "PreInstall_AllowDefferalCount" = '0'
   "SourceFolderPath" = 'D:\SourceContent'
   "Owner" = 'Joshua Duffney'
   "SupportContact" = 'Joshua Duffney'
   "EstimatedTime" = '5'
   "CatalogCategory" = 'Content Creator'
   "DeploymentTarget" = 'DeviceInstall' #Switch Options DeviceInstall,DeviceUninstall,UserInstall,UserUninstall
   "LimitingCollection" = 'All Systems' #Remove static input in function
   "ADGrpManager" = 'Joshua.Duffney'
   "DeploymentMode" = "Interactive"

<#----------- Optional Variables -------------#>
   "CopyFileName" = ''
   "CopyFileDestination" = ''
   "Transform" = 'AcroRead.mst'
   "Transformx64" = ''
   
<#---------- Static Variables -------------#>   
   "Arch" = 'x32/x64'
   "Lang" = 'EN'
   "Revision" = '01'
   "ScriptVersion" = '1.0.0'
   "ScriptAuthor" = 'Auto Generated'
   "SiteServerName" = 'Server01'
   "SiteCode" = 'PS01'
   "ShareContentFolder" = '\\Server01\SCCMDeployments\ContentSource'
   "PADTFiles" = '\\Server01\SCCMDeployments\Tools\PADTfiles'
   "ScriptType" = 'PowerShell'
   "ScriptContent" = 'blah'
   "MaximumAllowedRunTimeMinutes" = [int]5 *6
   "DetectDeploymentTypeByCustomScript" = '$true'   
   "ManualSpecifyDeploymentType" = '$true'
   "ScriptInstaller" = '$true'
   "Domain" = 'Domain'
   "DistributionPointGroupName" = 'PS1 Distribution'
   "AppExportLocation" = '\\Server01\SCCMDeployments\Exports'
   "UninstallProgram" = 'Deploy-Application.EXE -DeploymentType Uninstall -DeployMode Silent'
   
<#----------- Dynamic Variables ------------#>   
   "ApplicationSourceFolder" =''
   "ApplicationSourceContent" = ''
   "ApplicationFullName" =''
   "DeploymentCollectionName" = '' 
   "UninstallString" = ''
   "UninstallCodes" = ''
   "ADGRoupName" = ''
   "UninstallApplication" = ''
   "DeploymentTypeNameUninstall" = ''   
   "InstallationProgram" = ''
   "InstallationBehaviorType" = ''
   "DeploymentTypeName" = ''
   "InstallationProgramVisibility" = ''
   "DeployPurpose" = ''
   "LogonRequirementType" = ''
   "UserNotification" = ''
   "DeployAction" = ''
   }            

 ) 
          
$App.ApplicationSourceFolder = "$($App.Vendor)_$($App.Name)_$($App.Version)".Replace(' ','_')
$App.ApplicationSourceContent = $($App.ShareContentFolder) + "\" + "$($App.Vendor)_$($App.Name)_$($App.Version)".Replace(' ','_')
$App.ApplicationFullName = "$($App.Vendor) $($App.Name) $($App.Version)"
$App.DeploymentCollectionName = '' #Populated after ADgrpCMcollection function runs
$App.ADGRoupName = "$($App.Name) $($App.Version)"
$App.UninstallApplication = "$($App.Name)"
$App.DeploymentTypeNameUninstall = "$($App.Name) + 'Uninstall Silent'"

   Switch ($App.DeploymentMode) {
    
        "Silent" {
                   $App.InstallationProgram = 'Deploy-Application.EXE -DeployMode Silent'
                   $App.InstallationBehaviorType = 'InstallforSystem'
                   $App.DeploymentTypeName = $($App.Name) + " " + 'Install Silent'
                   $App.InstallationProgramVisibility = 'Hidden'
                   $App.DeployPurpose = 'Required' #(Required,Available)
                   $App.LogonRequirementType = 'WhetherOrNotUserLoggedOn'
                   $App.UserNotification = 'HideAll' #(DisplayAll,DisplaySoftwareCenterOnly,HideAll)
                   $App.DeployAction = 'Install' #(Install,Uninstall)

                   $AddCMDeploymentTypeParams = @{
                   'ApplicationName' = $App.ApplicationFullName;
                   'DeploymentTypeName' = $App.DeploymentTypeName;
                   'ScriptInstaller' = $true;
                   'ManualSpecifyDeploymentType' = $true;
                   'InstallationProgram' = $App.InstallationProgram;
                   'UninstallProgram' = $App.UninstallProgram;
                   'ContentLocation' = $App.ApplicationSourceContent;
                   'InstallationBehaviorType' = $App.InstallationBehaviorType;
                   'InstallationProgramVisibility' = $App.InstallationProgramVisibility;
                   'MaximumAllowedRunTimeMinutes' = $App.MaximumAllowedRunTimeMinutes;
                   'EstimatedInstallationTimeMinutes' = $App.EstimatedTime;
                   'DetectDeploymentTypeByCustomScript' = $true;
                   'ScriptType' = $App.ScriptType;
                   'ScriptContent' = $App.ScriptContent;
                   'LogonRequirementType' = $App.LogonRequirementType;
                   }

                 }

        "Interactive" {
                   $App.InstallationProgram = 'Deploy-Application.EXE'
                   $App.InstallationBehaviorType = 'InstallforSystem'
                   $App.DeploymentTypeName = $($App.Name) + " " + 'Install'
                   $App.InstallationProgramVisibility = 'Normal'
                   $App.DeployPurpose = 'Available' #(Required,Available)
                   $App.UserNotification = 'DisplayAll' #(DisplayAll,DisplaySoftwareCenterOnly,HideAll)
                   $App.DeployAction = 'Install' #(Install,Uninstall)

                   $AddCMDeploymentTypeParams = @{
                   'ApplicationName' = $App.ApplicationFullName;
                   'DeploymentTypeName' = $App.DeploymentTypeName;
                   'ScriptInstaller' = $true;
                   'ManualSpecifyDeploymentType' = $true;
                   'InstallationProgram' = $App.InstallationProgram;
                   'UninstallProgram' = $App.UninstallProgram;
                   'ContentLocation' = $App.ApplicationSourceContent;
                   'InstallationBehaviorType' = $App.InstallationBehaviorType;
                   'InstallationProgramVisibility' = $App.InstallationProgramVisibility;
                   'MaximumAllowedRunTimeMinutes' = $App.MaximumAllowedRunTimeMinutes;
                   'EstimatedInstallationTimeMinutes' = $App.EstimatedTime;
                   'DetectDeploymentTypeByCustomScript' = $true;
                   'ScriptType' = $App.ScriptType;
                   'ScriptContent' = $App.ScriptContent;
                        }

                    }


   }

Function Get-ConfigMgrFunctions {

Import-Module .\New-PADT.psm1
Import-Module .\New-ContentSource.psm1
Import-Module .\Get-MSIinfo.psm1
Import-Module .\Set-CMFolder.psm1
Import-Module .\New-ADGroupCMCollection.psm1

}

Get-ConfigMgrFunctions


$NewContentSource = @{
    'PADTFiles' = $App.PADTFiles
    'ApplicationSourceContent' = $App.ApplicationSourceContent
    'SourceFolderPath' = $app.SourceFolderPath
    }

New-ContentSource @NewContentSource

$Paths = (Get-ChildItem -path $App.SourceFolderPath -Recurse *.msi).FullName

    Foreach ($MSI in $Paths) { 
        if ($MSI) {
        $App.UninstallCodes +=Get-MSIinfo -Path "$MSI" -Property ProductCode
        }
    }

    $App.UninstallCodes = $App.UninstallCodes.trim()


$NewPADThash = @{
    'Vendor' = $App.Vendor
    'Name' = $App.Name
    'Version' = $App.Version
    'Arch' = $App.Arch
    'Lang' = $App.Lang
    'ScriptVersion' = $App.ScriptVersion
    'ScriptAuthor' = $App.ScriptAuthor
    'InstallFile' = $App.InstallFile
    'InstallString' = $App.InstallString
    'InstallFilex64' = $App.InstallFilex64
    'InstallStringx64' = $App.InstallStringx64
    'ScriptLocation' = $App.ApplicationSourceContent
    'CopyFileName' = $App.CopyFileName
    'CopyFileDestination' = $App.CopyFileDestination
    'SourceFolderPath' = $App.SourceFolderPath
    'UninstallCodes' = $App.UninstallCodes
    'Transform' = $app.Transform
    'Transformx64' = $app.Transformx64
    }

New-PADTScript @NewPADThash -ErrorAction Stop

Try
{
Write-Verbose "Connecting to $computername"
Import-Module "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1" -ErrorAction Stop
Set-Location "$($App.SiteCode):"
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
    Write-Verbose "Finished running command"
    "This Script attempted to import the SCCM module"
}

$NewCMApplication = @{
    'Name' = $App.ApplicationFullName
    'Owner' = $App.Owner
    'SupportContact' = $App.SupportContact
    'Publisher' = $App.Vendor
    'SoftwareVersion' = $App.Version
}

New-CMApplication @NewCMApplication -ErrorAction Stop | Out-Null

Add-CMDeploymentType @AddCMDeploymentTypeParams -ErrorAction Stop | Out-Null

$SetCMFolder = @{
    'ApplicationFullName' = $App.ApplicationFullName
    'Vendor' = $App.Vendor
    }

Set-CMfolder @SetCMFolder

Try
{
    $AppliactionID = (Get-CMApplication -name $Global:App.ApplicationFullName).CI_ID
    Set-CMApplication -Id $AppliactionID -DistributionPointSetting AutoDownload
}
Catch [System.Management.Automation.ItemNotFoundException]
{
    "No Applications found with $ApplicationID"
}
Catch
{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
}

Try
{
    $AppliactionID = (Get-CMApplication -name $Global:App.ApplicationFullName).CI_ID
    Set-CMApplication -Id $AppliactionID -UserCategories $Global:App.CatalogCategory
}
Catch [System.Management.Automation.ItemNotFoundException]
{
    "No Applications found with $ApplicationID"
}
Catch
{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
}

$NewADGrpCMCollection = @{
    'DeploymentTarget' = $App.DeploymentTarget
    'ADGrpManager' = $App.ADGrpManager
    'LimitingCollection' = $App.LimitingCollection
    'AppName' = $App.Name+$App.Version
    'Domain' = $App.Domain
    }


#NewADGrpCMCollection @NewADGrpCMCollection

$AppliactionID = (Get-CMApplication -name $App.ApplicationFullName).CI_ID
Start-CMContentDistribution -ApplicationID $AppliactionID -DistributionPointGroupName $App.DistributionPointGroupName| Out-Null
