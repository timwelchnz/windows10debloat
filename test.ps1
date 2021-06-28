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
add-content $path\oobe.xml $oobexmlStr -Verbose


$ScriptPath = $Env:windir + '\Setup\Scripts\'
If (-not(Test-Path -Path $ScriptPath -PathType Container)) {
    $null = New-Item -ItemType Directory -Path $ScriptPath -ErrorAction Continue
}
# Source file location
$source = 'https://raw.githubusercontent.com/timwelchnz/windows10debloat/main/afteroobe.ps1'
# Destination to save the file
$destination = $ScriptPath + 'afteroobe.ps1'
#Download the file
Invoke-WebRequest -Uri $source -OutFile $destination

$scriptStr = 'PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList ''-NoProfile -ExecutionPolicy Bypass -File ""afteroobe.ps1""'' -Verb RunAs}"'
$afteroobe = $ScriptPath + 'setupcomplete.cmd'
Add-Content -Path $afteroobe $scriptStr