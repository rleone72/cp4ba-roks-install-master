#!/bin/bash
# Add LDAP Bind user and passwort to the "ldap-bind-secret"
oc create secret generic ldap-bind-secret \
       	--from-literal=ldapUsername="CN=S00000450,OU=EFD-BIT-ELA-Server,OU=Server,OU=BIT,OU=LESD,DC=sszadmbit,DC=sszad,DC=admin,DC=ch" \
	--from-literal=ldapPassword="JhvH5CamJpvlQKru5ImE8Yg_7Vg73J9" \
       	--from-literal=ldapdb00048aUsername="CN=S00000450,OU=EFD-BIT-ELA-Server,OU=Server,OU=BIT,OU=LESD,DC=sszadmbit,DC=sszad,DC=admin,DC=ch" \
	--from-literal=ldapdb00048aPassword="JhvH5CamJpvlQKru5ImE8Yg_7Vg73J9" \
       	--from-literal=ldapdb00050aUsername="CN=S00000450,OU=EFD-BIT-ELA-Server,OU=Server,OU=BIT,OU=LESD,DC=sszadmbit,DC=sszad,DC=admin,DC=ch" \
	--from-literal=ldapdb00050aPassword="JhvH5CamJpvlQKru5ImE8Yg_7Vg73J9" \
       	--from-literal=ldapdb00051aUsername="CN=S00000450,OU=EFD-BIT-ELA-Server,OU=Server,OU=BIT,OU=LESD,DC=sszadmbit,DC=sszad,DC=admin,DC=ch" \
	--from-literal=ldapdb00051aPassword="JhvH5CamJpvlQKru5ImE8Yg_7Vg73J9" \

