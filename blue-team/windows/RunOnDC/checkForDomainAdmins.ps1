#search for DA's in the domain
$domainAdmins = Get-ADGroupMember -Identity "Domain Admins" -Recursive
$domainAdmins | Select-Object name | export-csv -path c:\export\domainAdmins.csv
#print out the DA's
write-host "Domain Admins (DA):"
$domainAdmins | Select-Object name
#search for peoople that can add themselves as DA's
#print out seperator
write-host "------------------------"
write-host "People that can add themselves as DA's:"
$addSelfToDA = Get-ADGroupMember -Identity "Add-User-To-Group" -Recursive
$addSelfToDA | Select-Object name | export-csv -path c:\export\addSelfToDA.csv
#print out the people that can add themselves as DA's
$addSelfToDA | Select-Object name
write-host "------------------------"
write-host "Removing anyone that isnt Administrator. If you see a user that is not an Administrator, they can add themselves as a DA."
#remove users that are not administrators
$addSelfToDA | Where-Object {$_.name -notmatch "Administrator"} | Remove-ADGroupMember -Identity "Add-User-To-Group"
#remove DAs that are not administrators
$domainAdmins | Where-Object {$_.name -notmatch "Administrator"} | Remove-ADGroupMember -Identity "Domain Admins"