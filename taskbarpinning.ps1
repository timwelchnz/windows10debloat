$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
$Name = "SearchboxTaskbarMode"
$value = "1"

If((Get-ItemPropertyValue -path $registryPath -Name $Name) -ne $value) {
    Set-ItemProperty -Path $registryPath -Name $Name -Value $value
}