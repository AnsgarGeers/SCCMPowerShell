#Gather Group Type and Application Name
Write-Host ("Provide the Application Name") -ForegroundColor Magenta
$App = Read-Host

Write-Host ("Please specify the type of group to create: InstallUser,InstallDevice,UninstallUser,UninstallDevice") -ForegroundColor Magenta
$GroupOptions = Read-Host

#Switch statement for 4 different group types
switch ($GroupOptions)
{
    "InstallUser"
    {
        $GroupName = 'SCCM-' + $App + 'InstallUser'
        $Description = "SCCM User Collection for $App"
    }
    "UninstallUser"
    {
        $GroupName = 'SCCM-' + $App + 'UninstallUser'
        $Description = "SCCM User Collection for $App"
    }
    "InstallDevice"
    {
        $GroupName = 'SCCM-' + $App + 'InstallDevice'
        $Description = "SCCM Device Collection for $App"
    }
    "UninstallDevice"
    {
        $GroupName = 'SCCM-' + $App + 'UninstallDevice'
        $Description = "SCCM Device Collection for $App"
    }
    default
    {
        Write-warning = 'Invalid input, please use InstallUser, InstallDevice, UninstallUser, or UninstallDevice'
    }
}

if (-Not ($GroupName -eq $null))
{
#Gather group manager
Write-Host ("Who is the manager of this group?") -ForegroundColor Magenta
$ManagedBy = Read-Host

#Display Group Info
Write-Host "Group name is $GroupName" -ForegroundColor Green
Write-Host "Manager is $ManagedBy" -ForegroundColor Green
Write-Host "Description is $Description" -ForegroundColor Green

## Create AD Group
New-ADGroup -GroupScope Global -GroupCategory Security -Name $GroupName -DisplayName $GroupName -SamAccountName $GroupName -ManagedBy $ManagedBy -Description $Description -Path "OU=Groups,OU=Kiewit,DC=KIEWITPLAZA,DC=com" -WhatIf

## Create Collections
if ($GroupName -Match 'User') {Write-Host "Creating new User Collection $GroupName" ; New-CMUserCollection -LimitingCollectionName "All Users and User Groups" -Name $GroupName -RefreshType ConstantUpdate -WhatIf} 
if ($GroupName -Match 'Device') {Write-Host "Creating new Device Collection $GroupName" ; New-CMDeviceCollection -LimitingCollectionName "All Systems" -Name $GroupName -RefreshType ConstantUpdate -WhatIf}

## Create MembershipQuery
if ($GroupName -Match 'User') {Write-Host "Creating new User Collection $GroupName" ; Add-CMUserCollectionQueryMembershipRule -CollectionName $GroupName -RuleName "Query-$GroupName" -QueryExpression "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.SystemGroupName = 'Domain\\$GroupName'" -WhatIf}
if ($GroupName -Match 'Device') {Write-Host "Creating new Device Collection Query $GroupName" ; Add-CMDeviceCollectionQueryMembershipRule -CollectionName $GroupName -RuleName "Query-$GroupName" -QueryExpression "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.SystemGroupName = 'Domain\\$GroupName'" -WhatIf}
}
