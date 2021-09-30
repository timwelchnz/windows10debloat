#Download and install the latest version of Winget CLI Package Managert
try {
    Get-Command "winget.exe" -ErrorAction Stop
}
catch {
    $latestRelease = Invoke-WebRequest https://github.com/microsoft/winget-cli/releases/latest -Headers @{"Accept"="application/json"} -UseBasicParsing
    $json = $latestRelease.Content | ConvertFrom-Json
    $latestVersion = $json.tag_name
    $url = "https://github.com/microsoft/winget-cli/releases/download/$latestVersion/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $download_path = "$env:USERPROFILE\Downloads\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Invoke-WebRequest -Uri $url -OutFile $download_path -UseBasicParsing
    Get-Item $download_path | Unblock-File
    Import-Module -Name Appx -Force
    Add-AppxPackage -Path $download_path -confirm:$false
}

Winget list
