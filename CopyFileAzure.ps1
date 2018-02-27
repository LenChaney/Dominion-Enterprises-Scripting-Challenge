# Challenge 3
# This challenge involves working with local and remote data in Azure.
# You are required to create a reusable PowerShell script that will enable you to copy the content​​s of C:/temp to an Azure file share.

# present user with interactive login for account
Login-AzureRmAccount

$resourceGroup = "DomEntChall"
$location = "East US"
$storageAccountName = "domentchallstorage"
$shrName = "challengefiles"

$getStor = Get-AzureRmStorageAccount -StorageAccountName $storageAccountName  -ResourceGroupName $resourceGroup | Select-Object
if ($getStor -ne $null) {
    # the share exists
    Write-Host "Storage Account [$getStor] exists"
}
if ($getStor -eq $null) {
    # share does not exist - tell the user to create it
    Write-Host "Storage Account does not exist [$getStor] creating ..."
    $getStor = New-AzureRmStorageAccount -Location $location -StorageAccountName $storageAccountName -ResourceGroupName $resourceGroup  -SkuName Standard_LRS
}


# get the context
$ctx = $getStor.Context

# create a new share
# but first see if it exists
$getshr = Get-AzureStorageShare -Name $shrName  -Context $ctx | Select-Object Name
if ($getshr -ne $null) {
    # the share exists
    Write-Host "Share existing [$getshr]"
}
if ($getshr -eq $null) {
    # share does not exist - create it
    Write-Host "Share does not exist [$getshr]"
    $shr = New-AzureStorageShare $shrName -Context $ctx 
}


# upload a single local file to the new directory
#Set-AzureStorageFileContent -Share $shr -Source C:\temp\ -Path $toDir

$CurrentFolder = (Get-Item -Path "c:\temp\" -Verbose).FullName
$Container = $shr

Write-Host "Current Folder:[$CurrentFolder]"
Write-Host "Current Container:[$Container]"

# loop through all the files in the c:\temp directory
Get-ChildItem -Path C:\temp\* -Recurse | Where-Object { $_.GetType().Name -eq "FileInfo"} | ForEach-Object {
    $path = $_.FullName.Substring($Currentfolder.Length).Replace("\", "/")
    # copy them to the file share at Azure
    Set-AzureStorageFileContent -Share $Container -Source $_.FullName -Path $path -Force
    # diagnostic output
    Write-Host "Copied Share[$Container] File:[$_.FullName] Path [$path]"
}
