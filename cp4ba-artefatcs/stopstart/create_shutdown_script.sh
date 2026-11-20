NAMESPACE=estv-fnsap-cp4ba-a

# scale down the operators (postgres excepted)
echo "# Scale down the operators" > stop_cp4ba_$NAMESPACE.sh
oc -n $NAMESPACE get deploy --no-headers -o name | grep operator | grep -v postgresql-operator | awk -v NS="$NAMESPACE" '{print "oc -n "NS" scale " $1 " --replicas=0"}' >> stop_cp4ba_$NAMESPACE.sh

# scale down all the deployments
echo "# Scale down the deployments" >> stop_cp4ba_$NAMESPACE.sh
oc -n $NAMESPACE get deploy --no-headers -o name | grep -v operator | awk -v NS="$NAMESPACE" '{print "oc -n "NS" scale " $1 " --replicas=0"}' >> stop_cp4ba_$NAMESPACE.sh

# scale down all the stateful sets
echo "# Scale down the stateful sets" >> stop_cp4ba_$NAMESPACE.sh
oc -n $NAMESPACE get sts --no-headers -o name | awk -v NS="$NAMESPACE" '{print "oc -n "NS" scale " $1 " --replicas=0"}' >> stop_cp4ba_$NAMESPACE.sh

# Fence EDB clusers
echo "# Fencing the EDB/PostgreSQL clusters" >> stop_cp4ba_$NAMESPACE.sh

echo "for edb in \$(oc -n $NAMESPACE get cluster -o name); do oc -n $NAMESPACE annotate \$edb k8s.enterprisedb.io/fencedInstances='[\"*\"]' ; done" >> stop_cp4ba_$NAMESPACE.sh

# echo oc -n $NAMESPACE annotate cluster zen-metastore-edb k8s.enterprisedb.io/fencedInstances=\'[\"*\"]\' >> stop_cp4ba_$NAMESPACE.sh
# echo oc -n $NAMESPACE annotate cluster ibm-bts-cnpg-$NAMESPACE-cp4ba-bts k8s.enterprisedb.io/fencedInstances=\'[\"*\"]\' >> stop_cp4ba_$NAMESPACE.sh

echo "# Wait for the operator to pickup/apply the change" >> stop_cp4ba_$NAMESPACE.sh
echo sleep 60 >> stop_cp4ba_$NAMESPACE.sh

# Stop the postgres operator
echo "# Scale down the PostgreSQL operator" >> stop_cp4ba_$NAMESPACE.sh
oc -n $NAMESPACE get deploy --no-headers -o name | grep postgresql-operator | awk -v NS="$NAMESPACE" '{print "oc -n "NS" scale " $1 " --replicas=0"}' >> stop_cp4ba_$NAMESPACE.sh

# Delete all remaining pods
echo "# Delete the remaining pods" >> stop_cp4ba_$NAMESPACE.sh
echo oc -n $NAMESPACE delete pod --all >> stop_cp4ba_$NAMESPACE.sh
