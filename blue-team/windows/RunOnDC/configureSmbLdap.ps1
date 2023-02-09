# disable null login and anonymous login
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name RestrictAnonymous -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name RestrictAnonymousSAM -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name EveryoneIncludesAnonymous -Value 0 -PropertyType DWORD -Force 
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters" -Name RequireSecuritySignature -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Reliability" -Name DontAddScheduledTasks -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters" -Name SMB1 -Value 0 -PropertyType DWORD -Force
Write-Host "Also run this script on any other Windows machines"