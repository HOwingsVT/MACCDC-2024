# backup of existing firewall rules
netsh advfirewall export "C:\backup\firewall\f.bak"

# flush firewall rules
Remove-NetFirewallRule

# add winrm 
winrm quickconfig
netsh advfirewall firewall add rule name="Winrm IN TCP 5985" dir=in action=allow protocol=TCP localport=5985
netsh advfirewall firewall add rule name="Winrm OUT TCP 5985" dir=out action=allow protocol=TCP localport=5985

netsh advfirewall firewall add rule name="Winrm IN UDP 5985" dir=in action=allow protocol=UDP localport=5985
netsh advfirewall firewall add rule name="Winrm OUT UDP 5985" dir=out action=allow protocol=UDP localport=5985

# add HTTP(s)
netsh advfirewall firewall add rule name="HTTP IN TCP 80" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="HTTP OUT TCP 80" dir=out action=allow protocol=TCP localport=80

netsh advfirewall firewall add rule name="HTTP IN UDP 80" dir=in action=allow protocol=UDP localport=80
netsh advfirewall firewall add rule name="HTTP OUT UDP 80" dir=out action=allow protocol=UDP localport=80

netsh advfirewall firewall add rule name="HTTPS IN TCP 443" dir=in action=allow protocol=TCP localport=443
netsh advfirewall firewall add rule name="HTTPS OUT TCP 443" dir=out action=allow protocol=TCP localport=443

netsh advfirewall firewall add rule name="HTTPS IN UDP 443" dir=in action=allow protocol=UDP localport=443
netsh advfirewall firewall add rule name="HTTPS OUT UDP 443" dir=out action=allow protocol=UDP localport=443

# add ssh
netsh advfirewall firewall add rule name="SSH IN TCP 20" dir=in action=allow protocol=TCP localport=20
netsh advfirewall firewall add rule name="SSH OUT TCP 20" dir=out action=allow protocol=TCP localport=20

netsh advfirewall firewall add rule name="SSH IN UDP 20" dir=in action=allow protocol=UDP localport=20
netsh advfirewall firewall add rule name="SSH OUT UDP 20" dir=out action=allow protocol=UDP localport=20

# add LDAP
netsh advfirewall firewall add rule name="LDAP IN TCP 389" dir=in action=allow protocol=TCP localport=389
netsh advfirewall firewall add rule name="LDAP OUT TCP 389" dir=out action=allow protocol=TCP localport=389

netsh advfirewall firewall add rule name="LDAP IN UDP 389" dir=in action=allow protocol=UDP localport=389
netsh advfirewall firewall add rule name="LDAP OUT UDP 389" dir=out action=allow protocol=UDP localport=389

netsh advfirewall firewall add rule name="LDAPS IN TCP 636" dir=in action=allow protocol=TCP localport=636
netsh advfirewall firewall add rule name="LDAPS OUT TCP 636" dir=out action=allow protocol=TCP localport=636

netsh advfirewall firewall add rule name="LDAPS IN TCP 636" dir=in action=allow protocol=UDP localport=636
netsh advfirewall firewall add rule name="LDAPS OUT TCP 636" dir=out action=allow protocol=UDP localport=636

# add DNS
netsh advfirewall firewall add rule name="DNS IN TCP 53" dir=in action=allow protocol=TCP localport=53
netsh advfirewall firewall add rule name="DNS OUT TCP 53" dir=out action=allow protocol=TCP localport=53

#add SMB
netsh advfirewall firewall add rule name="SMB IN TCP 445" dir=in action=allow protocol=TCP localport=445
netsh advfirewall firewall add rule name="SMB OUT TCP 445" dir=out action=allow protocol=TCP localport=445

#add RDP
netsh advfirewall firewall add rule name="RDP IN TCP 3389" dir=in action=allow protocol=TCP localport=3389
netsh advfirewall firewall add rule name="RDP OUT TCP 3389" dir=out action=allow protocol=TCP localport=3389

#add ICMP
netsh advfirewall firewall add rule name="ICMP IN" dir=in action=allow protocol=ICMPv4:8,any
netsh advfirewall firewall add rule name="ICMP OUT" dir=out action=allow protocol=ICMPv4:8,any

#add mysql and postgres
netsh advfirewall firewall add rule name="MYSQL IN TCP 3306" dir=in action=allow protocol=TCP localport=3306
netsh advfirewall firewall add rule name="MYSQL OUT TCP 3306" dir=out action=allow protocol=TCP localport=3306
netsh advfirewall firewall add rule name="POSTGRES IN TCP 5432" dir=in action=allow protocol=TCP localport=5432
netsh advfirewall firewall add rule name="POSTGRES OUT TCP 5432" dir=out action=allow protocol=TCP localport=5432

#add nfs
netsh advfirewall firewall add rule name="NFS IN TCP 2049" dir=in action=allow protocol=TCP localport=2049
netsh advfirewall firewall add rule name="NFS OUT TCP 2049" dir=out action=allow protocol=TCP localport=2049
