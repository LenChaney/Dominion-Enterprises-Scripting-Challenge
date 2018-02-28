# Challenge 1
# This challenge involves working with windows updates on remote machines.
# 
# You are required to create a reusable PowerShell script that will enable 
# you to find if a patch is installed on remote machines based on a 
# text file input of machine names. 
# The script should prompt for the patch name and the location of the input file.

# Bonus points - Prompt to install the patch if it doesn't exist.

# Test input files
# Exists
#    C:\Users\Win10Test\Documents\Projects\PSTests\ServerNames.txt
#    C:\Users\Win10Test\Documents\Projects\PSTests\Test.txt
# Not exist
#    C:\Users\Win10Test\Documents\Projects\PSTests\Text.txt

$inputFile = Read-Host "Location of input file "

# Check for existance of file
if (-NOT (Test-Path $inputFile -PathType Leaf -ErrorAction SilentlyContinue)) {
    Write-Host "Input file does NOT exist"
    Write-Host "Exiting ..."
    pause
    Return
}

Write-Host "Input file"
Write-Host "Path[$inputFile]"
Write-Host "Content:"
Write-Host "========"

Get-Content -Path $inputFile |
ForEach-Object {
   Write-Host "Server name [$_]"
}
pause


#$HotFixPattern = "Security*"
$HotFixPattern = "Update*"

# check the hotfixes
Get-Content -Path $inputFile | 
ForEach-Object {
    Write-Host "Server name [$_]"
    Get-HotFix -Description $HotFixPattern -ComputerName $_
}

#Get-HotFix
#Get-HotFix -Description "Security*" -ComputerName DESKTOP-2TLCSKU
#Get-HotFix  -ComputerName "Win10TestClone"
