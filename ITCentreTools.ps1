New-Item -Path "c:\" -Name "IT Centre" -ItemType "directory"
$Path = "\\172.20.20.2\Temp"
$Destination = "C:\IT Centre"
$AnyDesk = "\AnyDesk\IT Centre AnyDesk Setup.exe"
$SolarWinds = "\SolarWinds\AGENT.EXE"

Copy-Item -Path $Path$AnyDesk -Destination $Destination -Force
Copy-Item -Path $Path$SolarWinds -Destination $Destination -Force
$InstallFile = $AnyDesk.split("\")[2]
start-process -filepath "$Destination\$InstallFile" -wait -passthru
$InstallFile = $SolarWinds.split("\")[2]
start-process -filepath "$Destination\$InstallFile" -wait -passthru


