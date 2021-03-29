# TO RUN THIS SCRIPT FIRST CUT&PASTE & RUN THE BELOW LINE OUTSIDE OF THIS SCRIPT
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
Add-Type -AssemblyName System.Windows.Forms
Clear-Host
$DefaultRemove = @(

)

ForEach ($remove in $DefaultRemove) {
  
}

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