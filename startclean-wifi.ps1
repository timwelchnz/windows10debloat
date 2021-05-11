# The below needs to be exported from a current Working WiFi Profile
# On a working machine run "netsh wlan show profiles" to get the specific name of the profile you want to export
# Then run "netsh wlan export profile "contosowifi" key=clear folder=c:\temp" to produce an XML file you are going to copy into the below.
# 	<connectionMode>auto</connectionMode> Needs to be auto for WiFi to connect automatically.

$wlanProfile = @'
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
	<name>*** WLAN Profile Name ***</name>
	<SSIDConfig>
		<SSID>
			<hex></hex>
			<name>*** Your Network SSID ***</name>
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
				<protected>false</protected>
				<keyMaterial>*** Network Passkey ***</keyMaterial>
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
if (-Not (Test-Connection raw.githubusercontent.com -Quiet)) {
    Write-Host "Unable to connect to the internet"
    Exit
} Else {
    Write-Host "Connection Good"
}
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/timwelchnz/windows10debloat/main/AllInOneProgramRemoval.ps1'))
