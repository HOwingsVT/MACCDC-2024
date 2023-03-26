# follow steps in this article https://blog.netwrix.com/2021/08/24/active-directory-certificate-services-risky-settings-and-how-to-remediate-them/
Write-Host "If this errors out, check out: https://blog.netwrix.com/2021/08/24/active-directory-certificate-services-risky-settings-and-how-to-remediate-them/ and do once you get the rest of the config scripts run."
Import-Module -Name ActiveDirectory
Install-WindowsFeature -Name ADCS-Cert-Authority,ADCS-Web-Enrollment

Import-Module CertificateAuthority
Import-Module AdcsAdministration

certutil -config "CA CONNECTION STRING" -setreg policy\EditFlags - EDITF_ATTRIBUTESUBJECTALTNAME2
# setup CA requires manager approval
certutil -config "CA CONNECTION STRING" -setreg policy\EditFlags - EDITF_REQUIREMANAGERAPPROVAL

# Get all certificate templates in the CA
$CertificateTemplates = Get-CertificateTemplate

# Loop through each certificate template
foreach ($CertificateTemplate in $CertificateTemplates) {

  # Check if the "Enroll permission" is enabled for unauthorized users
  if ($CertificateTemplate.EnrollPermission -eq "Authenticated Users") {
    # Revoke the "Enroll permission" for unauthorized users
    $CertificateTemplate.EnrollPermission = "Administrators"
    Set-CertificateTemplate -Template $CertificateTemplate
  }

  # Check if the "Publish certificate in Active Directory" is enabled
  if ($CertificateTemplate.PublishCertificate -eq $true) {
    Write-Warning "The 'Publish certificate in Active Directory' is enabled for the '$($CertificateTemplate.TemplateDisplayName)' certificate template. Consider disabling the 'Publish certificate in Active Directory' setting for certificate templates that are not required to be published in the AD environment."
  }

  # Enable manager approval for certificate issuance
  if ($CertificateTemplate.RequestDisposition -ne "Enabled") {
    # Set the RequestDisposition setting to "NotSpecified" to enable manager approval for certificate issuance
    $CertificateTemplate.RequestDisposition = "Enabled"
    Set-CertificateTemplate -Template $CertificateTemplate
  }
}