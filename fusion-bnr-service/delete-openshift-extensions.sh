#!/usr/bin/env bash
set -euo pipefail

# Delete specific OpenShift objects if they exist.
# Requires oc CLI access and a logged-in session.

NAMES=(
  icp4adeploy-ban-zen-extension
  icp4adeploy-cmis-zen-extension
  icp4adeploy-cp4ba-zen-extension
  icp4adeploy-cpe-zen-extension
  icp4adeploy-graphql-zen-extension
  icp4adeploy-workspace-aae-zen-ext
)

log() {
  printf "%s\n" "$*"
}

delete_resource() {
  local kind="$1"
  local name="$2"
  local namespace="$3"

  if [[ -n "$namespace" ]]; then
    log "Deleting $kind/$name in namespace $namespace"
    # Delete the namespaced resource if present; ignore errors when it does not exist.
    oc delete "$kind" "$name" -n "$namespace" --ignore-not-found
  else
    log "Skipping cluster-scoped $kind/$name (only namespace-scoped resources are handled)"
  fi
}

find_and_delete() {
  local kind="$1"
  local namespace
  local candidates

  namespace=$(oc project -q 2>/dev/null || true)
  if [[ -z "$namespace" ]]; then
    log "Unable to determine current namespace. Ensure oc is logged in and a project is selected."
    return
  fi

  # List namespaced resources in the current namespace and capture name + namespace.
  candidates=$(oc get "$kind" -n "$namespace" -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace --no-headers 2>/dev/null || true)

  while IFS= read -r line; do
    if [[ -z "$line" ]]; then
      continue
    fi

    local name=$(awk '{print $1}' <<< "$line")

    for target in "${NAMES[@]}"; do
      if [[ "$name" == "$target" ]]; then
        delete_resource "$kind" "$name" "$namespace"
      fi
    done
  done <<< "$candidates"
}

main() {
  log "Checking for target objects in the current namespace..."

  # Gather namespaced resource types from oc.
  local kinds
  kinds=$(oc api-resources --verbs=list -o name 2>/dev/null || true)

  if [[ -z "$kinds" ]]; then
    log "No API resources available. Ensure oc is installed and logged in."
    exit 1
  fi

  while IFS= read -r kind; do
    if [[ -z "$kind" ]]; then
      continue
    fi

    # Determine whether the resource is namespaced; ignore cluster-scoped resources.
    local resource_info
    resource_info=$(oc api-resources --verbs=list --namespaced -o wide | grep "^$kind " || true)
    if [[ -n "$resource_info" ]]; then
      find_and_delete "$kind" true
    else
      log "Skipping cluster-scoped resource kind: $kind"
    fi
  done <<< "$kinds"

  log "Finished checking target objects."
}

main "$@"
