#!/bin/bash
# --------------------------- OCP functions --------------------

# Function used to delete specific resources, such as pods, replicasets, etc.
function oc_cleanup () {
    local type="${1:-pod}"
    local pattern="${2:-Completed}"

    echo "Deleting ${type} matching ${pattern}"
    for resource in $(oc get ${type} --no-headers | grep "${pattern}" | cut -f 1 -d " "); do 
        echo "Matching ${type}: ${resource}"
        oc delete ${type} ${resource};
    done
}

# Function to sort the events by date
function oc_events () {
	{
		echo $'TIME\tNAMESPACE\tTYPE\tREASON\tOBJECT\tSOURCE\tMESSAGE';
		oc get events -o json "$@" \
			| jq -r  '.items | map(. + {t: (.eventTime//.lastTimestamp)}) | sort_by(.t)[] | [.t, .metadata.namespace, .type, .reason, .involvedObject.kind + "/" + .involvedObject.name, .source.component + "," + (.source.host//"-"), .message] | @tsv';
	} \
		| column -s $'\t' -t \
		| less -S
}

# Function used to restart a job
function oc_restart_job () {
    local job="${1}"

oc get job ${job} -o json | jq 'del(.spec.selector)' | jq 'del(.spec.template.metadata.labels)' | kubectl replace --force -f -
}

# Function to list the pods that require attention (number of ready containers is not equal to total number of containers)
function oc_pod_status () {
    watch "oc get pods --all-namespaces | grep -v "Completed" | grep -Ev '([0-9]+)/\1'"
}

# --------------------------- Resource Management --------------------

# Function used to display all the pods resource requests
function oc_requests () {
    local resource="${1:-cpu}"

    for pod in $(oc get pods -o name); do
        echo -e "$(oc get $pod -o jsonpath='{.spec.containers[*].resources.requests.'"${resource}"'}') \t $pod"
    done
}

# Function used to display all the pods resource requests
function oc_limits () {
    local resource="${1:-cpu}"

    for pod in $(oc get pods -o name); do
        echo -e "$(oc get $pod -o jsonpath='{.spec.containers[*].resources.limits.'"${resource}"'}') \t $pod"
    done
}


# Function used to display the nodes resource usage
function oc_nodes_usage () {
    oc describe nodes --selector node-role.kubernetes.io/worker | grep 'Name:\|  cpu\|  memory'
}

# Function used to display the top pods by CPU usage
function oc_top_pods () {
    local resource="${1:-cpu}"
    local options="${2:-}"
    local cpu_key=2
    local memory_key=3

    if [ "${options}" = "-A" ]; then
        cpu_key=3
	memory_key=4
    fi

    if [ "${resource}" = "cpu" ]; then
        watch "oc adm top pod ${options} --no-headers | sort --reverse --key $cpu_key --numeric"
    elif [ "${resource}" = "memory" ]; then
        watch "oc adm top pod ${options} --no-headers | sort --reverse --key $memory_key --numeric"
    else
        echo "Unknown key: ${resource}"
    fi
}


