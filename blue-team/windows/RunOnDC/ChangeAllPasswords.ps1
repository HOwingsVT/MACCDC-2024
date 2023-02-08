#change all user passwords in the domain and print progress
# requires admin rights
# requires ActiveDirectory module
# Change password complexity to 0
Set-ADDefaultDomainPasswordPolicy -Identity (Get-ADDomain).DistinguishedName -ComplexityEnabled $false

# Define the password to set for all users
$password = Read-Host "Enter the password for all users"

# Get all users in the domain
$users = Get-ADUser -Filter *

# Change the password for each user and print progress in percent
foreach ($user in $users) {
    Write-Progress -Activity "Changing passwords" -Status "Changing password for $($user.name)" -PercentComplete (($users.IndexOf($user) + 1) / $users.Count * 100)
    Set-ADAccountPassword -Identity $user.DistinguishedName -NewPassword (ConvertTo-SecureString $password -AsPlainText -Force)
    set-aduser $user -ChangePasswordAtLogon:$true
}
