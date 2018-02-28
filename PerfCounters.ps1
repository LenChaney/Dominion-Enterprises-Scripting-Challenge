# Challenge 2
# 
# This challenge involves working with performance counters.
#
# You are required to create a reusable PowerShell script that will enable you to retrieve the following performance counters from a remote machine:
#
# Iron Scripter 2018: Prequel 5
# https://powershell.org/wp-content/uploads/2018/02/Iron-Scripter-Prequel-Puzzle-5-A-commentary.pdf
#
# Processor: Percentage processor time (use the total if there are multiple processors in the system)
#   
#  Processor              MultiInstance The Processor performance object consists of counters that measure aspects of processor activity. The pro...
#  Processor Information  MultiInstance The Processor Information performance counter set consists of counters that measure aspects of processor ...
#   
# Disk: Percentage Free space of the C: drive
#   
# Memory: Percentage Committed Bytes in Use
#   Memory                SingleInstance The Memory performance object  consists of counters that describe the behavior of physical and virtual me...
#   
# Network Adapter: Bytes Total per second
#    Network Adapter      MultiInstance The Network Adapter performance object consists of counters that measure the rates at which bytes and pac...

# All counters
#    Get-Counter -ListSet *  | Sort-Object CounterSetName | Format-Table CounterSetName, CounterSetType, Description
# use this command to get the counter paths
#    Get-Counter -ListSet "Processor" | select -ExpandProperty Counter

$decimalRound = 4

# let the user enter a remote computer name
$computer = ""
$computer = Read-Host "Computer [localhost]"


# Processor: Percentage processor time (use the total if there are multiple processors in the system)
if ($computer -eq ""){
    $counter = (Get-Counter -Counter "\Processor(_total)\% Processor Time").CounterSamples.CookedValue
} Else {
    $counter = (Get-Counter -Computer "$computer" -Computer "$computer" -Counter "\Processor(_total)\% Processor Time").CounterSamples.CookedValue
}
$counter = [math]::round( $counter , $decimalRound ) 

Write-Host "Processor: Percentage processor time total [$counter]" 

# Disk: Percentage Free space of the C: drive
if ($computer -eq ""){
    $counter = (Get-Counter  -Counter "\LogicalDisk(C:)\% Free Space").CounterSamples.CookedValue
} Else {
    $counter = (Get-Counter  -Computer "$computer" -Counter "\LogicalDisk(C:)\% Free Space").CounterSamples.CookedValue
}
$counter = [math]::round( $counter , $decimalRound) 
Write-Host "Disk: Percentage Free space of the C: drive [$counter]" 

# Memory: Percentage Committed Bytes in Use
if ($computer -eq ""){
    $counter = (Get-Counter -Counter "\Memory\% Committed Bytes In Use").CounterSamples.CookedValue
} Else {
    $counter = (Get-Counter -Computer "$computer"  -Counter "\Memory\% Committed Bytes In Use").CounterSamples.CookedValue
}
$counter = [math]::round( $counter , $decimalRound) 
Write-Host "Memory: Percentage Committed Bytes in Use [$counter]" 

# Network Adapter: Bytes Total per second
# add all the totals together
if ($computer -eq ""){
    $counter = (Get-Counter -Counter "\Network Adapter(*)\Bytes Total/sec").CounterSamples.CookedValue
} Else {
    $counter = (Get-Counter -Computer "$computer"  -Counter "\Network Adapter(*)\Bytes Total/sec").CounterSamples.CookedValue
}
#$counter = [math]::round( $counter , $decimalRound) 
Write-Host "Network Adapter: Bytes Total per second [$counter]" 

