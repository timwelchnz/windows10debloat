#Run Windows Updates

$PackageProvider = "NuGet"
if (Get-PackageProvider -ListAvailable -Name $PackageProvider) {
    Write-Host "NuGet Installed"
}
else {
    Install-PackageProvider -Name NuGet -Force
}

$Module = "PSWindowsUpdate"
if (Get-Module -ListAvailable -Name $Module) {
    Write-Host "Running Windows Update"
} 
else {
    Install-Module PSWindowsUpdate -Confirm:$false -Force
}
Get-WindowsUpdate -install -acceptall -Confirm:$false
# Install-WindowsUpdate -Confirm:$false