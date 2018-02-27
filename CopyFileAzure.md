Required
========
*** Make a Resource Group of "DomEntChall" or change the variable on line 8 to a resource group that exists in your Azure account ***

Code
====
The code is located on GitHub at https://github.com/LenChaney/Dominion-Enterprises-Scripting-Challenge I'm not sure what your email system will strip out but at a minimum, script files would get it.
CopyFileAzure.ps1

Powershell
==========
Version: 
	Microsoft Azure PowerShell 
	Version: 5.3.0 Date: 
	13 Feb 2018 
installed through Web Platform Installer

Azure
=====
I used an interactive login. You should be able to use your own Azure account although I can get you my developer credentials in needed

Coordinating instructions
=========================
Hardcoded Values
*** Must be created prior to running script:
-----------------
Resource Group:  $resourceGroup = "DomEntChall"  - must be created before running script

Housekeeping:
-----------------
Location: $location = "East US"

Created if not present
----------------------
Storage Account: $storageAccountName = "domentchallstorage" 
File Share: $shrName = "challengefiles"


Running the Script
=========================
Make a Resource Group of DomEntChall or change the variable on line 8 to a resource group that exists in your Azure account
Run CopyFileAzure.ps1
Logon with Azure credentials

Other
=====
No error suppression so you will see red text but you can ignore it
if a resource does not exist but that resource will be created



RandomId will be 3 characters between 100 and 999 Servername is max of 15 characters I included the function of Show-VMSizeManu to demonstrate that I know how to use Functions
