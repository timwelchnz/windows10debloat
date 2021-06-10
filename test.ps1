$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"

$Name = "SearchboxTaskbarMode"
$value = "1"
$SearchBar = Get-Item -Path $registryPath


$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
$Name = "DontEnumerateConnectedUsers"
$value = "0"
New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord


rename-computer -NewName CDL-MAIN-01 -WhatIf