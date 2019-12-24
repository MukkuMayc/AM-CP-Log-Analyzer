#change this variables with desired values
$domainName = "thdom.internal"
$scopeName = "thscope" 
$startRange = "192.168.148.20"
$endRange = "192.168.148.100"
$subnetMask = "255.255.255.0"
$scopeID = "192.168.148.0"
$thisMachineIP = "192.168.148.29"
#router is likely your default gateway
$router = "192.168.148.2"
$dnsServer = $thisMachineIP 



Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $domainName 

#on dc - list of comps on domain 
#get-ADComputer | Format-Table DNSHostName, Enabled, Name, SamAccountName

#check if dns role in installed
#Get-WindowsFeature | where {($_.name -like “DNS”)}

#add dhcp role, static ip is likely required by that moment
Install-WindowsFeature DHCP -IncludeManagementTools
netsh dhcp add securitygroups

#likely installed by that moment, need to conf ip stuffs
Add-DHCPServerv4Scope -Name $scopeName -StartRange $startRange -EndRange $endRange -SubnetMask $subnetMask -State Active
#Remove-DhcpServerv4Scope -ScopeId 192.168.148.0
Set-DHCPServerv4OptionValue -ScopeID $scopeID -DnsDomain $domainName -DnsServer $dnsServer -Router $router 
Add-DhcpServerInDC -DnsName $domainName -IpAddress $thisMachineIP 
#Remove-DhcpServerInDC -DnsName secdom.internal -IpAddress 192.168.148.29
#verify:
#Get-DhcpServerv4Scope
#Get-DhcpServerInDC

Restart-service dhcpserver
#on client:
#netsh interface ip set dns name="Ethernet0" static 1.1.1.1
#Add-Computer -DomainName secdom.internal

