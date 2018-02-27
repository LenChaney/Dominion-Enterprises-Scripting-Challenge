# Challenge 2
# This challenge involves working with Azure to create virtual machines.

# You are required to create a reusable PowerShell script that will enable you to 
# create Azure virtual machines from your local machine. 
# The script should prompt you at the command line to enter all the required data to build a server in Azure.
# 
# resource group: 
# I'll use a resource group to keep these challenge resource isolated
# 
# 
function Show-VMSizeMenu
{
     param (
           [string]$Title = 'VM Size'
     )
     cls
    Write-Host "================== $Title ===================="
     
    Write-Host "0: A0 Standard 1 Core/0.75GB/ 1 data disk"
    Write-Host "1: A1 Standard 1 Core/1.75GB/ 2 data disks"
    Write-Host "2: A2 Standard 2 Core/3.50GB/ 4 data disks"
    Write-Host "3: A3 Standard 4 Core/7.00GB/ 8 data disks"
    Write-Host "4: A4 Standard 8 Core/14.0GB/16 data disks"
}
# Present an interactive login
Login-AzureRmAccount

# Get the credentials for the server we are creatng
$cred = Get-Credential -Message "Enter an Admin username and password for the virtual machine."

# Hardcode the following variables for common values
$resourceGroup = "DomEntChall"
$location = "East US"

# Random ID to enforce uniquiness in resource name
$RandomId = (Get-Random -Minimum 100 -Maximum 999)

# Get the VM size from the user
Show-VMSizeMenu("Choose a size for the VM")
$input = Read-Host "Please make a selection"
switch ($input)
{
    '9' {
        $vmSize = "Standard_A0"
    }'1' {
        $vmSize = "Standard_A1"
    } '2' {
        $vmSize = "Standard_A2"
    } '3' {
        $vmSize = "Standard_A3"
    } '4' {
        $vmSize = "Standard_A4"
    } 'q' {
        return
    }
}

# Get the name of the VM and allow a default
$vmDefaultName = "Chall-$RandomId"
$vmName = Read-Host "Enter desired name of VM[$vmDefaultName]"
switch ($vmName)
{
    '' {
    # If no name was entered, use the default
        $vmName = $vmDefaultName
    }
}

Write-Host "VM Name: " $vmName
Write-Host "VM Size: " $vmSize
pause


# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name mySubnet1 -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup -Location $location -Name "dcvNET-$RandomId" -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$publicIp = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -Location $location -Name "dcpublicdns-$RandomId" -AllocationMethod Static -IdleTimeoutInMinutes 4
$publicIp | Select-Object Name,IpAddress

$dcNSG = "myNetworkSecurityGroup-$RandomId"

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name $dcNSG -SecurityRules $nsgRuleRDP

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name "myNic-$RandomId" -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id -NetworkSecurityGroupId $nsg.Id

# Just in case it was set for another size, make it the smallest possible
# so we don't kill my Azure credits  
$vmSize = "Standard_A0"

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize |
  Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred |
  Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest |
  Add-AzureRmVMNetworkInterface -Id $nic.Id

# Create a virtual machine
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig
