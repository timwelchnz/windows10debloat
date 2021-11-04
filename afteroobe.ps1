# Tim Welch
# 28/06/2021
# Script to run immediately after OOBE to clean things up.

#Set Search Bar to Icon
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
$Name = "SearchboxTaskbarMode"
$value = "1"
$SearchBar = Get-Item -Path $registryPath
If($null -eq $SearchBar.GetValue($Name)) {
  New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
} else {
  Set-ItemProperty -Path $registryPath -Name $Name -Value $value
}

#Remove Task View Button
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Name = "ShowTaskViewButton"
$value = "0"
$TaskBar = Get-Item -Path $registryPath
If($null -eq $TaskBar.GetValue($Name)) {
  New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
} else {
  Set-ItemProperty -Path $registryPath -Name $Name -Value $value
}

#Show My Computer on the Desktop
$Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
$Name = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
$Exist = "Get-ItemProperty -Path $Path -Name $Name"
if ($Exist)
{
    Set-ItemProperty -Path $Path -Name $Name -Value 0
}
Else
{
    New-ItemProperty -Path $Path -Name $Name -Value 0
}

# Remove News And Interests
$registryPath = "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
$Name = "ShellFeedsTaskbarViewMode"
$value = "2"
new-item 'HKLM:SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Feeds'
$TaskBar = Get-Item -Path $registryPath
If($null -eq $TaskBar.GetValue($Name)) {
   New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
} else {
   Set-ItemProperty -Path $registryPath -Name $Name -Value $value
}

#Unpin Microsoft Store
$appname = "Microsoft Store"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{$_.Name -eq $appname}).Verbs() | Where-Object{$_.Name.replace('&','') -match 'Unpin from taskbar'} | ForEach-Object{$_.DoIt(); $exec = $true}

#Remove Cortana Button - This is unneeded as we remove Cortana entirely. It doesn't work in NZ
# $registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
# $Name = "ShowCortanaButton"
# $value = "0"
# $Cortana = Get-Item -Path $registryPath
# If($null -eq $Cortana.GetValue($Name)) {
#   New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
# } else {
#   Set-ItemProperty -Path $registryPath -Name $Name -Value $value
# }
# Write-Host "Removed Cortana Button"

#Rename PC and reboot
If (Test-Path -Path "C:\temp\computername.txt") {
  $NewComputerName = get-content "C:\temp\computername.txt"
  Rename-Computer -NewName $NewComputerName -Force
}
else {
  Write-Host "Unable to rename PC - do it manually"
}
#Remove remaining files
Remove-Item -Path "C:\temp\*" -Force
Restart-Computer -Force -Confirm:$false