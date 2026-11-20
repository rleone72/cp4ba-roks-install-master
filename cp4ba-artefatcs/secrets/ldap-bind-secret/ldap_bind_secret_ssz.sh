#!/bin/bash
# Add LDAP Bind user and passwort to the "ldap-ssz-bind-secret"
oc create secret generic ldap-ssz-bind-secret \
       	--from-literal=ldapUsername="CN=S00000450,OU=EFD-BIT-ELA-Server,OU=Server,OU=BIT,OU=LESD,DC=sszadmbit,DC=sszad,DC=admin,DC=ch" \
	--from-literal=ldapPassword="JhvH5CamJpvlQKru5ImE8Yg_7Vg73J9" \
	
