# ---------------------------------------------------
# Version: 1.0
# Author: Joshua Duffney
# Date: 07/18/2014
# Description: Create CM Catalog Categories from a .txt file
# Comments: Populate the names of the desired catalog categories line by line in catalogcategories.txt
# ---------------------------------------------------

$File = "c:\scripts\catalogcategories.txt"

ForEach ($Category in (Get-Content $File))
{
    $CategoryTest =  Get-CMCategory -Name "$Category"
    
    if ($CategoryTest -eq $null){
    New-CMCategory -CategoryType CatalogCategories -Name $Category | Out-Null
    Write-Host -ForegroundColor Green "$Category Created"
    } 
    else 
    {
    Write-Host -ForegroundColor red "$Category already exists"
    }
}
