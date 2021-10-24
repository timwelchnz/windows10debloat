@powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$_=((Get-Content \"%~f0\") -join \"`n\");iex $_.Substring($_.IndexOf(\"goto :\"+\"EOF\")+9)"
@goto :EOF
If (-Not (Get-NetConnectionProfile).IPv4Connectivity -contains "Internet") { 
	$Wifi = netsh wlan show networks
	$networks = (($Wifi -match '\d\s:').split(":") -replace "^SSID\s\d+").trim() | ? {$_.trim() -ne ""}
	If ($networks -match "Wcomp Dirty") {
	$wlanProfile = @'
	<?xml version="1.0"?>
	<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
		<name>Wcomp Dirty</name>
		<SSIDConfig>
			<SSID>
				<hex></hex>
				<name>Wcomp Dirty</name>
			</SSID>
		</SSIDConfig>
		<connectionType>ESS</connectionType>
		<connectionMode>auto</connectionMode> 
		<MSM>
			<security>
				<authEncryption>
					<authentication>WPA2PSK</authentication>
					<encryption>AES</encryption>
					<useOneX>false</useOneX>
				</authEncryption>
				<sharedKey>
					<keyType>passPhrase</keyType>
					<protected>true</protected>
					<keyMaterial>01000000D08C9DDF0115D1118C7A00C04FC297EB01000000876A30FF993E3144825BA037B1F492A2000000000200000000001066000000010000200000003225BBD96BC77A7B8CD70F639DF0C80AA627F8D314C40412FCCE8BC82EF46E6C000000000E80000000020000200000002306EA1CBDFA3EDAD503A066A5C0E2F2ED8B3DCE41E2FDEE2B5CF019818838D01000000014B909386FBC455780A7C86DB137CD3140000000913C361EEE33168DE85D3A52C20BA740FE7F6727C7077B8BFFFC525963699FC8402630E9CEBD133C72D809D90B42A188A4B755C89A0450CCB7A7A8D8E12853C4</keyMaterial>
				</sharedKey>
			</security>
		</MSM>
		<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
			<enableRandomization>false</enableRandomization>
			<randomizationSeed>686733486</randomizationSeed>
		</MacRandomization>
	</WLANProfile>
'@
	Set-Content -Path $env:TEMP\wlan.xml -Value $wlanProfile
	netsh wlan add profile filename=$env:TEMP\wlan.xml
	}
	Else {
		Write-host "Manually connect Wi-Fi or Ethernet..." -BackgroundColor Red
		Read-host -Prompt "Press a key to continue when connected"
	}
}
# Test Network Connection
[int]$SleepTimer = "2" #seconds to attempt after 
[int]$Attempts = "5"
$AttemptsCounter = 0
$RemainingAttempts = $Attempts - $AttemptsCounter
Write-Host "Testing to see if netowrk connection is avilable..."
while($RemainingAttempts -gt 0) {
    if(Test-Connection raw.githubusercontent.com -Quiet -Count 1) {
        Write-Host "Network connection is Good!" -BackgroundColor Green -ForegroundColor Black
        break
    } else {
        Write-Host "Network is not connected. Retrying..." -BackgroundColor Red
        Start-Sleep -Seconds ($SleepTimer)
        $RemainingAttempts--
    }
}
if($RemainingAttempts -eq 0) {
    Write-Host "Maximum number of attempts reached trying to connection to the internet"
    Write-Host "Internet Connection Failed" -BackgroundColor Red
    Exit
}
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/timwelchnz/windows10debloat/main/stage1.ps1'))
