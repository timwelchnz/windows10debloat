@ECHO OFF
PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""startclean-wifi.ps1""' -Verb RunAs}"
PowerShell.exe -NoProfile -Command "Write-Host $env:TEMP\log.txt"