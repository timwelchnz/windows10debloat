Function Log {
  param(
    [Parameter(Mandatory=$true)][String]$msg
)
Add-Content -Path $env:TEMP\log.txt $msg
}

$nextStage = "stage2.bat"
$dir = "C:\temp"
$url = "https://raw.githubusercontent.com/timwelchnz/windows10debloat/main/$($nextStage)"
$download_path = "$($dir)\$($nextStage)"
$Exist = (Test-Path -Path $dir)
If (-not $Exist ) {
    New-Item -Path $dir -ItemType directory
}
Invoke-WebRequest -Uri $url -OutFile $download_path -UseBasicParsing
Get-Item $download_path | Unblock-File

#Set Language to NZ 
Set-Culture en-NZ
Set-WinSystemLocale -SystemLocale en-NZ
Set-TimeZone -Name 'New Zealand Standard Time'
Set-WinHomeLocation -GeoId 0xb7
Set-WinUserLanguageList en-NZ -Force -Confirm:$false

#Rename Computer
Log "Renaming Computer"
Write-Host "Current computer name is: $env:COMPUTERNAME"
$NewComputerName = Read-Host "Enter new computer name, or just hit [Enter] to rename to serial number"
If ("" -eq $NewComputerName){
    $NewComputerName = Get-CimInstance -ClassName Win32_BIOS -Property SerialNumber | Select-Object -ExpandProperty SerialNumber
} 
Rename-Computer -NewName $NewComputerName -Force
Log "Renamed computer: $NewComputerName"

$value = $download_path
$name = "!$($nextStage)"
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce'
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType $PropertyType
# Remove for Production
Read-Host -Prompt "Restart"
# Restart-Computer -Force -Confirm:$false