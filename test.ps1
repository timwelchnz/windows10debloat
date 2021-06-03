if ($null -eq  (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd31.exe' -ErrorAction SilentlyContinue).'(Default)' -ErrorAction SilentlyContinue).VersionInfo) {
    Write-Host "Does not exist"

}