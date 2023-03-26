#Author: S1n1st3r

Import-Module ActiveDirectory

#search for DA's in the domain
$domainAdmins = Get-ADGroupMember -Identity "Domain Admins" -Recursive
$domainAdmins | Select-Object name | export-csv -path c:\domainAdmins.csv
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

write-host "`nRemoving users out of groups unless they belong by default.`n"

try{
	foreach( $user in (Get-AdGroupMember -Identity "Administrators") ){
		if( $user.SamAccountName -eq "Administrator" ){
			continue
		} elseif( $user.SamAccountName -eq "Domain Admins" ){
			continue
		} elseif( $user.SamAccountName -eq "Enterprise Admins" ){
			continue
		}

		Remove-ADGroupMember -Identity "Administrators" -Member $user.SAMAccountName -confirm:$false
		write-host "`nRemoved $user.SAMAccountName from Administrators"
	}
} catch {
	write-warning "Administrators : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Domain Admins") ){
		if( $user.SAMAccountName -eq "Administrator" ){
			continue
		}
		Remove-ADGroupMember -Identity "Domain Admins" -Member $user.SAMAccountName -confirm:$false
		write-host "`nRemoved $user.SAMAccountName from Domain Admins"
	}
} catch {
	write-warning "Domain Admins : Group does not exist in the AD"
}
try{
	foreach( $user in (Get-ADGroupMember -Identity "Access Control Assistance Operators") ){
		Remove-ADGroupMember -Identity "Access Control Assistance Operators" -Member $user.SAMAccountName -confirm:$false
		write-host "`nRemoved $user.SAMAccountName from Access Control Assistance Operators"
	}
} catch {
	write-warning "Access Control Assistance Operators : Group does not exist in the AD"
}

try {
	foreach( $user in (Get-ADGroupMember -Identity "Account Operators") ){
		Remove-ADGroupMember -Identity "Account Operators" -Member $user.SAMAccountName -confirm:$false
		write-host "`nRemoved $user.SAMAccountName from Account Operators"
	}
} catch {
	write-warning "Account Operators : Group does not exist in the AD"
}

try {
	foreach( $user in (Get-ADGroupMember -Identity "DnsAdmins") ){
		if( $user.SAMAccountName -eq "Administrator" ){
			continue
			# By default, no one is in this group. But I do not know if removing administrator from this group
			# does not allow administrator to edit DNS. Will test soon.
		}
		Remove-ADGroupMember -Identity "DnsAdmins" -Member $user.SAMAccountName -confirm:$false
		write-host "`nRemoved $user.SAMAccountName from DnsAdmins"
	}
} catch {
	write-warning "DnsAdmins : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Domain Guests") ){
		if( $user.SAMAccountName -eq "Guest" ){
			$user = Get-ADUser -Identity "Guest"
			if( $user.Enabled -eq "True" ){
				Disable-ADAccount -Identity $user.SAMAccountName
				write-host "Disabled Guest Account"
			}
			continue
		}
		Remove-ADGroupMember -Identity "Domain Guests" -Member $user.SAMAccountName -confirm:$false
		write-host "`nRemoved $user.SAMAccountName from Domain Guests"
	}
} catch {
	write-warning "Domain Guests : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Enterprise Admins") ){
		if( $user.SamAccountName -eq "Administrator" ){
			continue
		}
		Remove-ADGroupMember -Identity "Enterprise Admins" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Enterprise Admins"?
	}
} catch {
	write-warning "Enterprise Admins : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Enterprise Key Admins") ){
		Remove-ADGroupMember -Identity "Enterprise Key Admins" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Enterprise Key Admins"
	}
} catch {
	write-warning "Enterprise Key Admins : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Event Log Readers") ){
		Remove-ADGroupMember -Identity "Event Log Readers" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Event Log Readers"
	}
} catch {
	write-warning "Event Log Readers : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Group Policy Creators Owners") ){
		if( $user.SamAccountName -eq "Administrator" ){
			continue
		}
		Remove-ADGroupMember -Identity "Group Policy Creators Owners" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Group Policy Creators Owners"
	}
} catch {
	write-warning "Group Policy Creators Owners : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Guests") ){
		if( $user.SAMAccountName -eq "Guest" ){
			$user = Get-ADUser -Identity "Guest"
			if( $user.Enabled -eq "True" ){
				Disable-ADAccount -Identity $user.SAMAccountName
				write-host "Disabled Guest Account"
			}
			continue
		} elseif( $user.SAMAccountName -eq "Domain Guests"){
			continue
		}
		Remove-ADGroupMember -Identity "Guests" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Guests"
	}
} catch {
	write-warning "Guests : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Hyper-V Administrators") ){
		Remove-ADGroupMember -Identity "Hyper-V Administrators" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Hyper-V Administrators"
	}
} catch {
	write-warning "Hyper-V Administrators : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "IIS_ISURS") ){
		if( $user.SamAccountName -eq "IUSR" ){
			continue
		}
		Remove-ADGroupMember -Identity "IIS_ISURS" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from IIS_ISURS"
	}
} catch {
	write-warning "IIS_ISURS : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Remote Desktop Users") ){
		Remove-ADGroupMember -Identity "Remote Desktop Users" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Remote Desktop Users"
	}
} catch {
	write-warning "Remote Desktop Users : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Remote Management Users") ){
		Remove-ADGroupMember -Identity "Remote Management Users" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Remote Management Users"
	}
} catch {
	write-warning "Remote Management Users : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Schema Admins") ){
		if( $user.SamAccountName -eq "Administrator" ){
			continue
		}
		Remove-ADGroupMember -Identity "Schema Admins" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Schema Admins"
	}
} catch {
	write-warning "Schema Admins : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "WinRMRemoteWMIUsers_") ){
		Remove-AdGroupMember -Identity "WinRMRemoteWMIUsers_" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from WinRMRemoteWMIUsers_"
	}
} catch {
	write-warning "WinRMRemoteWMIUsers_ : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "Storage Replica Administrators") ){
		Remove-AdGroupMember -Identity "Storage Replica Administrators" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from Storage Replica Administrators"
	}
} catch {
	write-warning "Storage Replica Administrators : Group does not exist in the AD"
}

try{
	foreach( $user in (Get-ADGroupMember -Identity "System Managed Accounts Group") ){
		if($user.SAMAccountName -eq "DefaultAccount"){
			continue
		}
		Remove-AdGroupMember -Identity "System Managed Accounts Group" -Member $user.SAMAccountName -confirm:$false
		write-host "Removed $user.SAMAccountName from System Managed Accounts Group"
	}
} catch {
	write-warning "System Managed Accounts Group : Group does not exist in the AD"
}
