Function Log {
    param(
        [Parameter(Mandatory=$true)][String]$msg
    )
    Add-Content -Path $env:TEMP\log.txt $msg
}

$url = "https://raw.githubusercontent.com/timwelchnz/windows10debloat/main/stage2.ps1"
$download_path = "$Env:TEMP\stage2.ps1"
Invoke-WebRequest -Uri $url -OutFile $download_path -UseBasicParsing
Get-Item $download_path | Unblock-File
$value = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -command '$($download_path)'"
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name '!Stage2' -Value $value

Clear-Host

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
Restart-Computer -Force -Confirm:$false