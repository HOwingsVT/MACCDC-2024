# follow steps in this article https://blog.netwrix.com/2021/08/24/active-directory-certificate-services-risky-settings-and-how-to-remediate-them/

certutil -config "CA CONNECTION STRING" -setreg policy\EditFlags - EDITF_ATTRIBUTESUBJECTALTNAME2
# setup CA requires manager approval
certutil -config "CA CONNECTION STRING" -setreg policy\EditFlags - EDITF_REQUIREMANAGERAPPROVAL