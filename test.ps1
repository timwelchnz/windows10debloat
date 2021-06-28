$path = "$Env:windir\System32\Oobe\Info\"
If (-not(Test-Path -Path $path -PathType Container)) {
    $null = New-Item -ItemType Directory -Path $path -ErrorAction STOP
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

$scriptStr = 'PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList ''-NoProfile -ExecutionPolicy Bypass -File ""startclean-wifi.ps1""'' -Verb RunAs}"'
Add-Content -Path "$Env:windir\Setup\Scripts\setupcomplete.cmd" $scriptStr