Import-Module GroupPolicy

# Define the name of the GPO
$GPO = "AD Domain Security Settings"

# Create a new GPO
New-GPO -Name $GPO

# Link the GPO to the domain
New-GPLink -Name $GPO -Target "dc=<domain name>,dc=<tld>"

# Define the security settings to be applied
$SecuritySettings = @{
    "PowerShell Script Block Logging" = "Enabled"
    "Accounts: Limit local account use of blank passwords to console logon only" = "Enabled"
    "Microsoft network server: Digitally sign communications (always)" = "Enabled"
    "Microsoft network server: Digitally sign communications (if client agrees)" = "Disabled"
    "Microsoft network server: Server SPN target name validation level" = "Accept if provided by client"
    "Reset account lockout counter after" = "30"
    "Restrict NTLM authentication" = "Enabled"
    "Network security: LAN Manager authentication level" = "Send NTLMv2 response only. Refuse LM & NTLM"
    "RDP port restriction" = "Enabled"
    "Require Network Level Authentication" = "Enabled"
    "WinRM listener restriction" = "Enabled"
    "Encrypt WinRM traffic" = "Enabled"
    "PowerShell Script Block Logging Location" = "C:\Users\Administrator\Desktop\"
}

# Apply the security settings to the GPO
foreach ($Setting in $SecuritySettings.GetEnumerator()) {
    Set-GPRegistryValue -Name $GPO -Key "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" -ValueName $Setting.Key -Type DWORD -Value $Setting.Value
}

# Force a GPO update on all domain controllers and self
Invoke-GPUpdate -Force -Computer "DC1"
Invoke-GPUpdate -Force -Computer "DC2"
Invoke-GPUpdate -Force -Computer $env:COMPUTERNAME
# Add additional domain controllers as needed
Write-host "GPO update complete. Run 'gpoupdate /force' on all machines. On Linux run 'sudo gpupdate /force' or 'sudo adgpupdate -V'"
