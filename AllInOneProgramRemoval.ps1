# TO RUN THIS SCRIPT FIRST CUT&PASTE & RUN THE BELOW LINE OUTSIDE OF THIS SCRIPT
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

#Add Windows Forms Assembly as it seems to be missing on a lot of machines
Add-Type -AssemblyName System.Windows.Forms

Clear-Host

#Unpin Microsoft Store from Taskbar - https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html
$appname = "Microsoft Store"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}

#Set Search Bar to Icon
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
$Name = "SearchboxTaskbarMode"
$value = "1"

$SearchBar = Get-Item -Path $registryPath
If($SearchBar.GetValue($Name) -eq $null) {
  New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
} else {
  Set-ItemProperty -Path $registryPath -Name $Name -Value $value
}

#Remove Task View Button
$registryPath = HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced
$Name = "ShowTaskViewButton"
$value = "0"

$TaskBar = Get-Item -Path $registryPath
If($TaskBar.GetValue($Name) -eq $null) {
  New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
} else {
  Set-ItemProperty -Path $registryPath -Name $Name -Value $value
}

#Remove Cortana Button
$registryPath = HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced
$Name = "ShowCortanaButton"
$value = "0"

#Provisioned App Removal List and afterwards loop through the remaining...
$DefaultRemove = @(
    "Microsoft.549981C3F5F10"
    "Microsoft.BingWeather"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MixedReality.Portal"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.Whiteboard"
    "Microsoft.WindowsAlarms"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

ForEach ($toremove in $DefaultRemove) {
    Get-ProvisionedAppxPackage -Online | Where-Object DisplayName -EQ $toremove | Remove-ProvisionedAppxPackage -Online -AllUsers
    Write-Host "REMOVED" $toremove
}

$continue = [System.Windows.Forms.MessageBox]::Show("Do you want to continue through remaining AppX Packages?","Batch Windows 10 App Removal", "YesNo" , "Information" , "Button1")
Switch ($continue) {
    'Yes' {}
    'No' {
      Exit
    }

}


# Now retrieve remaining Provisioned Packages...
$ProvisionedFiles = @(Get-ProvisionedAppxPackage -Online | Select-Object DisplayName)

ForEach ($files in $ProvisionedFiles) {
    $msg   = "Remove " + $files.DisplayName + "?"
    $remove = [System.Windows.Forms.MessageBox]::Show($msg,"Batch Windows 10 App Removal", "YesNo" , "Information" , "Button1")
    switch  ($remove) {
      'Yes' {
        Get-ProvisionedAppxPackage -Online | Where-Object DisplayName -EQ $files.DisplayName | Remove-ProvisionedAppxPackage -Online -AllUsers
        Write-Host "REMOVED" $files.DisplayName
          }
      'No' {
        Write-Host "Kept" $files.DisplayName
          }
    }
}

