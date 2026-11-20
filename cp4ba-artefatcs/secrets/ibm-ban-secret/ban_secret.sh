oc create secret generic ibm-ban-secret \
 --from-literal=navigatorDBUsername="M_ICNCFG02" \
 --from-literal=navigatorDBPassword="WvoUfhzzaWqqD52a2Nr" \
 --from-literal=keystorePassword="WvoUfhzzaWqqD52a2Nr" \
 --from-literal=ltpaPassword="WvoUfhzzaWqqD52a2Nr" \
 --from-literal=appLoginUsername="S00000448" \
 --from-literal=appLoginPassword="8ImVb2hkJCRqA_vUMP13QSeS5itOgwf" \
 --from-literal=jMailUsername="mailadmin" \
 --from-literal=jMailPassword="{xor}GDoxNiosbg=="
