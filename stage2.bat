@powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$_=((Get-Content \"%~f0\") -join \"`n\");iex $_.Substring($_.IndexOf(\"goto :\"+\"EOF\")+9)"
@goto :EOF

$nextStage = "stage3.bat"
$dir = "C:\temp"
$url = "https://raw.githubusercontent.com/timwelchnz/windows10debloat/main/$($nextStage)"
$download_path = "$($dir)\$($nextStage)"
$Exist = (Test-Path -Path $dir)
If (-not $Exist ) {
    New-Item -Path $dir -ItemType directory
}
Invoke-WebRequest -Uri $url -OutFile $download_path -UseBasicParsing
Get-Item $download_path | Unblock-File

Write-Host "Re-running Windows Update as it then installs the latest Optional Updates"
Get-WindowsUpdate -install -acceptall -IgnoreReboot -Confirm:$false -Verbose
Read-Host "Did Get-WindowsUpdate work?"

Write-Host "Cleaning Up Temp Files"
$clnmgr = "cleanmgr.exe"
$arguments = "/AUTOCLEAN"
start-process $clnmgr $arguments -NoNewWindow -Wait
Read-Host "Did CleanMgr Work?"

# Add 3rd stage to RunOnce Registry Key
$value = "$($dir)\$($nextStage)"
$name = "!$($nextStage)"
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name $name -Value $value -Force
Restart-Computer -Force -Confirm:$false