#!/usr/bin/env bash
set -u

# Usage
# 
# Dry run (safe preview):
# 
# ./delete-zen-extensions.sh my-namespace --dry-run
# 
# Actual deletion:
# 
# ./delete-zen-extensions.sh my-namespace

NAMESPACE="${1:-}"
DRY_RUN="${2:-}"
RESOURCE_TYPE="zenextension"
SLEEP_SECONDS=5
TIMEOUT_SECONDS=900   # 15 minutes

if [[ -z "$NAMESPACE" ]]; then
  echo "Usage: $0 <namespace> [--dry-run]"
  exit 1
fi

RESOURCES=(
  "icp4adeploy-ban-zen-extension"
  "icp4adeploy-cmis-zen-extension"
  "icp4adeploy-cp4ba-zen-extension"
  "icp4adeploy-cpe-zen-extension"
  "icp4adeploy-graphql-zen-extension"
  "icp4adeploy-workspace-aae-zen-ext"
)

EXPECTED_COUNT=${#RESOURCES[@]}
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
LOG_FILE="delete_zenextensions_${NAMESPACE}_${TIMESTAMP}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $*"
}

resource_exists() {
  local name="$1"
  oc get "$RESOURCE_TYPE" "$name" -n "$NAMESPACE" >/dev/null 2>&1
}

count_target_resources() {
  local count=0
  local name
  for name in "${RESOURCES[@]}"; do
    if resource_exists "$name"; then
      count=$((count + 1))
    fi
  done
  echo "$count"
}

print_target_status() {
  local name
  for name in "${RESOURCES[@]}"; do
    if resource_exists "$name"; then
      log "[OK]      $name"
    else
      log "[MISSING] $name"
    fi
  done
}

get_total_count() {
  oc get "$RESOURCE_TYPE" -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | tr -d ' '
}

wait_with_timeout() {
  local start_time="$1"
  local now elapsed
  now="$(date +%s)"
  elapsed=$((now - start_time))
  if (( elapsed >= TIMEOUT_SECONDS )); then
    log "❌ Timeout reached after ${TIMEOUT_SECONDS}s"
    exit 1
  fi
}

INITIAL_TOTAL_COUNT="$(get_total_count)"
START_TIME="$(date +%s)"

log "===== START ====="
log "Namespace: $NAMESPACE"
log "Resource type: $RESOURCE_TYPE"
log "Expected target resources: $EXPECTED_COUNT"
log "Initial total $RESOURCE_TYPE count in namespace: $INITIAL_TOTAL_COUNT"
log "Log file: $LOG_FILE"

if [[ "$DRY_RUN" == "--dry-run" ]]; then
  log "Mode: DRY-RUN (no resources will be deleted)"
else
  log "Mode: LIVE (resources will be deleted)"
fi

echo

for NAME in "${RESOURCES[@]}"; do
  if [[ "$DRY_RUN" == "--dry-run" ]]; then
    log "[DRY-RUN] Would delete $RESOURCE_TYPE/$NAME"
  else
    log "Deleting $RESOURCE_TYPE/$NAME ..."
    oc delete "$RESOURCE_TYPE" "$NAME" -n "$NAMESPACE" --ignore-not-found=true || true
  fi
done

echo

if [[ "$DRY_RUN" == "--dry-run" ]]; then
  log "===== END ====="
  log "Done."
  exit 0
fi

log "Phase 1: Waiting until all target resources are deleted..."

while true; do
  wait_with_timeout "$START_TIME"
  CURRENT_TARGET_COUNT="$(count_target_resources)"

  if [[ "$CURRENT_TARGET_COUNT" -eq 0 ]]; then
    log "✅ All target resources are deleted."
    break
  fi

  log "⏳ Still existing target resources: $CURRENT_TARGET_COUNT / $EXPECTED_COUNT"
  print_target_status
  echo "----------------------------------------"
  sleep "$SLEEP_SECONDS"
done

echo
log "Phase 2: Waiting until all target resources are recreated..."

while true; do
  wait_with_timeout "$START_TIME"
  CURRENT_TARGET_COUNT="$(count_target_resources)"
  CURRENT_TOTAL_COUNT="$(get_total_count)"

  log "Current recreated target resources: $CURRENT_TARGET_COUNT / $EXPECTED_COUNT"
  log "Current total $RESOURCE_TYPE count: $CURRENT_TOTAL_COUNT / initial $INITIAL_TOTAL_COUNT"
  print_target_status

  if [[ "$CURRENT_TARGET_COUNT" -eq "$EXPECTED_COUNT" ]]; then
    log "✅ All target resources are back."
    log "===== END ====="
    log "Done."
    exit 0
  fi

  echo "----------------------------------------"
  sleep "$SLEEP_SECONDS"
done