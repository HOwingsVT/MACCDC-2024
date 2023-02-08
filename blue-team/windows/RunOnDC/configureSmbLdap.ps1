# disable null login and anonymous login
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name RestrictAnonymous -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name RestrictAnonymousSAM -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name EveryoneIncludesAnonymous -Value 0 -PropertyType DWORD -Force 
