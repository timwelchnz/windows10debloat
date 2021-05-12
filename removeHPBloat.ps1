$AppsToRemove = @(
    'HP Documentation'
    'HP Client Security Manager'
    'HP Connection Optimizer'
    'HP Notifications'
    'HP Security Update Service'
    'HP Sure Click'
    'HP Sure Sense Installer'
    )

$RegKeys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
    )

$Apps = $RegKeys |
    Get-ChildItem |
    Get-ItemProperty |
    Where-Object { $AppsToRemove -contains $_.DisplayName -and $_.UninstallString }

foreach( $App in $Apps ){
    $UninstallString = if( $App.Uninstallstring -match '^msiexec' ){
            "$( $App.UninstallString -replace '/I', '/X' ) /qn /norestart /quiet"
            }
        else{
            $App.UninstallString
            }

    Write-Verbose $UninstallString

    Start-Process -FilePath cmd -ArgumentList '/c', $UninstallString -NoNewWindow -Wait
    }

# Remove HP Shortcuts
Remove-Item -LiteralPath "C:\ProgramData\HP\TCO" -Force -Recurse
Remove-Item -LiteralPath "C:\Online Services" -Force -Recurse
Remove-Item -Path "C:\Users\Public\Desktop\TCO Certified.lnk" -Force -Recurse

#Remove Adobe Trial Shortcuts
Remove-Item -LiteralPath "C:\Program Files (x86)\Online Services" -Force -Recurse
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Proefversies.lnk" -Force -Recurse