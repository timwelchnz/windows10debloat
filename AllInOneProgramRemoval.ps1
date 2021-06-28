# TO RUN THIS SCRIPT FIRST CUT&PASTE & RUN THE BELOW LINE OUTSIDE OF THIS SCRIPT
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Or run as a bat file with powershell.exe -executionpolicy bypass -file "AllInOneProgramRemoval.ps1"

#Logging for debugging
Function Log {
  param(
      [Parameter(Mandatory=$true)][String]$msg
  )
  Add-Content -Path $env:TEMP\log.txt $msg
}

#Add Windows Forms Assembly as it seems to be missing on a lot of machines
Add-Type -AssemblyName System.Windows.Forms

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
$continue = [System.Windows.Forms.MessageBox]::Show("Do you want to rename this computer from $env:COMPUTERNAME ?","Computer Rename", "YesNo" , "Information" , "Button1")
Switch ($continue) {
  'Yes' {
    $NewComputerName = Read-Host "Enter new computer name, or just hit [Enter] to rename to serial number"
    If ("" -eq $NewComputerName){
      $NewComputerName = Get-CimInstance -ClassName Win32_BIOS -Property SerialNumber | Select-Object -ExpandProperty SerialNumber
    } 
    Rename-Computer -NewName $NewComputerName
    Log "Renamed computer: $NewComputerName"
  }
  'No' {
  }
}

$path = $Env:windir + '\system32\oobe\info\'
If (-not(Test-Path -Path $path -PathType Container)) {
    $null = New-Item -ItemType Directory -Path $path -ErrorAction Continue
}
$oobexmlStr = @"
<FirstExperience>
  <oobe>
    <defaults>
      <language>1033</language>
      <location>183</location>
      <keyboard>1409:00000409</keyboard>
      <timezone>New Zealand Standard Time</timezone>
      <adjustForDST>true</adjustForDST>
    </defaults>
  </oobe>
</FirstExperience>
"@
add-content $path\oobe.xml $oobexmlStr

Log "Unpin Microsoft Store"
#Unpin Microsoft Store from Taskbar - https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html
$appname = "Microsoft Store"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}

Log "Set Search Bar to Icon"
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

Log "Remove Task View Button"
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
Log "Removed Task View Button"

Log "Remove Cortana Button"
#Remove Cortana Button
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Name = "ShowCortanaButton"
$value = "0"
$Cortana = Get-Item -Path $registryPath
If($null -eq $Cortana.GetValue($Name)) {
  New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
} else {
  Set-ItemProperty -Path $registryPath -Name $Name -Value $value
}

Log "Show My Computer on the Desktop"
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

Log "Remove Meet Now from Taskbar"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$Name = "HideSCAMeetNow"
$value = "1"
$Exist = Get-ItemProperty -Path $registryPath -Name $Name
if ($Exist) {
    Set-ItemProperty -Path $registryPath -Name $Name -Value $value
} Else {
    New-ItemProperty -Path $registryPath -Name $Name -Value $value -PropertyType DWord
}

Log "Disable Turn-on Automatic Setup of Network Connected Devices"
# DISABLE 'TURN ON AUTOMATIC SETUP OF NETWORK CONNECTED DEVICES' (Automatically adds printers)
New-Item -Path "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup" -Name "Private"
New-ItemProperty "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Name "AutoSetup" -Value 0 -PropertyType "DWord"

Log "Started Provisioned App Removal"
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
    "Microsoft.MSPaint"
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
    Get-ProvisionedAppxPackage -Online | Where-Object DisplayName -EQ $toremove | Remove-ProvisionedAppxPackage -Online -AllUsers | Out-Null
    Log "REMOVED: $toremove"
}
Log "Completed automatic removal of provisioned apps"

#Remove Paint 3D edit from Explorer Context
$AppExtensions = @(
    ".bmp"
    ".gif"
    ".jpeg"
    ".jpg"
    ".jpe"
    ".png"
    ".tiff"
    ".tif"
)
ForEach ($AppExtension in $AppExtensions) {
  Remove-Item -Path "HKLM:\SOFTWARE\Classes\SystemFileAssociations\$AppExtension\Shell\3D Edit" -Recurse
}
Log "Removed Paint3D from Explorer Context"

Log "About to ask to continue to step through the rest of the provisoned apps"
$continue = [System.Windows.Forms.MessageBox]::Show("Do you want to continue through remaining AppX Packages?","Batch Windows 10 App Removal", "YesNo" , "Information" , "Button1")
# Write-Host "Do you want to continue through remaining AppX Packages? [y]es or [n]o"
# $continue = $Host.UI.RawUI.ReadKey()
Switch ($continue) {
    'Yes' {
        # Now retrieve remaining Provisioned Packages...
        $ProvisionedFiles = @(Get-ProvisionedAppxPackage -Online | Select-Object DisplayName)

        ForEach ($files in $ProvisionedFiles) {
            $msg   = "Remove " + $files.DisplayName + "?"
            $remove = [System.Windows.Forms.MessageBox]::Show($msg,"Batch Windows 10 App Removal", "YesNo" , "Information" , "Button1")
            switch  ($remove) {
              'Yes' {
                Get-ProvisionedAppxPackage -Online | Where-Object DisplayName -EQ $files.DisplayName | Remove-ProvisionedAppxPackage -Online -AllUsers | Out-Null
                Log "REMOVED: $files.DisplayName"
                Write-Host "REMOVED: $files.DisplayName"
                  }
              'No' {
                Log "Kept: $files.DisplayName"
                Write-Host "Kept: $files.DisplayName"
                  }
            }
        }
        Log "Completed stepping through the rest of the provisoned apps"
    }
    'No' {
    }

}


$StartLayoutStr = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6">
        <start:Group Name="Internet">
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationID="MSEdge" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationID="Chrome" />
        </start:Group>
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

# This changes the default user start menu and the currently logged in user
add-content $Env:TEMP\startlayout.xml $StartLayoutStr
import-startlayout -layoutpath $Env:TEMP\startlayout.xml -mountpath $Env:SYSTEMDRIVE\
New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows -Name Explorer -ErrorAction SilentlyContinue
Reg Add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V LockedStartLayout /T REG_DWORD /D 1 /F
Reg Add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V StartLayoutFile /T REG_EXPAND_SZ /D '$Env:TEMP\startlayout.xml' /F
Stop-Process -ProcessName explorer
Start-Sleep -s 10
#sleep is to let explorer finish restart b4 deleting reg keys
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Force
Stop-Process -ProcessName explorer
remove-item $Env:TEMP\startlayout.xml -ErrorAction SilentlyContinue -Force
Log "Completed importing new Start Menu"

Log "Beginning Installation of Chocolatey and apps"
#Installation of Chocolatey and Apps
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation

$chromeInstalled = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo
if ($null -eq $chromeInstalled.FileName) {
  choco install googlechrome --ignore-checksum -y 
  Log "Chrome installed"
}
else {
  Log "Chrome already installed"
}

$AcrobatReaderInstalled = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe').'(Default)').VersionInfo
if ($null -eq $AcrobatReaderInstalled.FileName) {
  choco install adobereader -y
  Log "Adobe Reader installed"
}
else {
  Log "Adobe Reader already installed"
}
Log "Completed installation of chocolatey and apps"

#Run Windows Updates
Install-PackageProvider -Name NuGet -Force 
Install-Module PSWindowsUpdate -Confirm:$false -Force
Get-WindowsUpdate -install -acceptall -autoreboot -Confirm:$false -Verbose


