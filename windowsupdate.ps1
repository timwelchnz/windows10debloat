$Module = "PSWindowsUpdate"
if (Get-Module -ListAvailable -Name $Module) {
    Write-Host "Running Windows Update"
} 
else {
    Install-Module PSWindowsUpdate -Confirm:$false -Force
}
Get-WindowsUpdate -Confirm:$false
Install-WindowsUpdate -Confirm:$false