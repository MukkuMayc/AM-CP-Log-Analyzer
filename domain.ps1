Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "secdom.internal"

#on dc - list of comps on domain 
#get-ADComputer | Format-Table DNSHostName, Enabled, Name, SamAccountName

#check if dns role in installed
#Get-WindowsFeature | where {($_.name -like “DNS”)}

#add dhcp role, static ip is likely required by that moment
Install-WindowsFeature DHCP -IncludeManagementTools
netsh dhcp add securitygroups

#likely installed by that moment, need to conf ip stuffs
Add-DHCPServerv4Scope -Name “secdomscope” -StartRange 192.168.148.20 -EndRange 192.168.148.100 -SubnetMask 255.255.255.0 -State Active
#Remove-DhcpServerv4Scope -ScopeId 192.168.148.0
Set-DHCPServerv4OptionValue -ScopeID 192.168.148.0 -DnsDomain secdom.internal -DnsServer 192.168.148.29 -Router 192.168.148.2
Add-DhcpServerInDC -DnsName secdom.internal -IpAddress 192.168.148.29
#Remove-DhcpServerInDC -DnsName secdom.internal -IpAddress 192.168.148.29
#verify:
#Get-DhcpServerv4Scope
#Get-DhcpServerInDC

Restart-service dhcpserver
#on client:
#netsh interface ip set dns name="Ethernet0" static 1.1.1.1
#Add-Computer -DomainName secdom.internal

