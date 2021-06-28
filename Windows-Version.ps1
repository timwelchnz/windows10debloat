$editions = @{
    0 = 'Undefined'
    1 = 'Ultimate Edition'
    2 = 'Home Basic Edition'
    3 = 'Home Premium Edition'
    4 = 'Enterprise Edition'
    5 = 'Home Basic N Edition'
    6 = 'Business Edition'
    7 = 'Standard Server Edition'
    8 = 'Datacenter Server Edition'
    9 = 'Small Business Server Edition'
    10 = 'Enterprise Server Edition'
    11 = 'Starter Edition'
    12 = 'Datacenter Server Core Edition'
    13 = 'Standard Server Core Edition'
    14 = 'Enterprise Server Core Edition'
    15 = 'Enterprise Server Edition for Itanium-Based Systems'
    16 = 'Business N Edition'
    17 = 'Web Server Edition'
    18 = 'Cluster Server Edition'
    19 = 'Home Server Edition'
    20 = 'Storage Express Server Edition'
    21 = 'Storage Standard Server Edition'
    22 = 'Storage Workgroup Server Edition'
    23 = 'Storage Enterprise Server Edition'
    24 = 'Server For Small Business Edition'
    25 = 'Small Business Server Premium Edition'
    29 = 'Web Server, Server Core'
    39 = 'Datacenter Edition without Hyper-V, Server Core'
    40 = 'Standard Edition without Hyper-V, Server Core'
    41 = 'Enterprise Edition without Hyper-V, Server Core'
    42 = 'Microsoft Hyper-V Server'
    43 = 'Storage Server Express Edition (Server Core installation)'
    44 = 'Storage Server Standard Edition (Server Core installation)'
    45 = 'Storage Server Workgroup Edition (Server Core installation)'
    46 = 'Storage Server Workgroup Edition (Server Core installation)'
    48 = 'Windows Professional'
    50 = 'Windows Server Essentials (Desktop Experience installation)'
    63 = 'Small Business Server Premium (Server Core installation)'
    64 = 'Windows Compute Cluster Server without Hyper-V'
    97 = 'Windows RT'
    101 = 'Windows Home'
    103 = 'Windows Professional with Media Center'
    104 = 'Windows Mobile'
    123 = 'Windows IoT (Internet of Things) Core'
    143 = 'Windows Server Datacenter Edition (Nano Server installation)'
    144 = 'Windows Server Standard Edition (Nano Server installation)'
    147 = 'Windows Server Datacenter Edition (Server Core installation)'
    148 = 'Windows Server Standard Edition (Server Core installation)'
}
  
$sku = (Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU

'Edition is {0}' -f $editions.[int]$sku