NAMESPACE=estv-fnsap-cp4ba-a

# Save the replica count for reference if needed
oc -n $NAMESPACE get sts,deploy --no-headers | awk -v NS="$NAMESPACE" '{split($2,a,"/"); print $1 " = "a[2]}' > replica_count_cp4ba_$NAMESPACE.txt

# Start the postgres operator
echo "# Start the PostgreSQL operator" > start_cp4ba_$NAMESPACE.sh
oc -n $NAMESPACE get deploy --no-headers | grep postgresql-operator | awk -v NS="$NAMESPACE" '{split($2,a,"/"); print "oc -n "NS" scale deploy " $1 " --replicas="a[2]}' >> start_cp4ba_$NAMESPACE.sh
echo "# Wait for the operator to start" >> start_cp4ba_$NAMESPACE.sh
echo sleep 30 >> start_cp4ba_$NAMESPACE.sh

# Un-fence EDB clusers
echo "# Un-fencing the EDB/PostgreSQL clusters" >> start_cp4ba_$NAMESPACE.sh
echo "for edb in \$(oc -n $NAMESPACE get cluster -o name); do oc -n $NAMESPACE annotate \$edb k8s.enterprisedb.io/fencedInstances- ; done" >> start_cp4ba_$NAMESPACE.sh
echo "# Wait for the operator to pickup/apply the change" >> start_cp4ba_$NAMESPACE.sh
echo sleep 60 >> start_cp4ba_$NAMESPACE.sh

# scale up all the stateful sets and deployments
echo "# Scale up the stateful sets and deployments" >> start_cp4ba_$NAMESPACE.sh
oc -n $NAMESPACE get sts,deploy --no-headers | awk -v NS="$NAMESPACE" '{split($2,a,"/"); print "oc -n "NS" scale " $1 " --replicas="a[2]}' >> start_cp4ba_$NAMESPACE.sh
