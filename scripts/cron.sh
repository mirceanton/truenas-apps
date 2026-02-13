#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
    echo "Usage: $0 <repo-dir>" >&2
    exit 1
fi

REPO_DIR="$1"
COMPOSE_DIR="${REPO_DIR}/bootstrap"
LOG_TAG="doco-cd-update"

log() {
    echo "[${LOG_TAG}] $*"
    logger -t "$LOG_TAG" "$*"
}

cd "$REPO_DIR"

git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    log "No changes."
    exit 0
fi

git pull --ff-only

if git diff --quiet "${LOCAL}" HEAD -- bootstrap/; then
    log "Changes pulled but none in bootstrap/, skipping compose."
    exit 0
fi

log "Changes detected in bootstrap/, running docker compose up..."
cd "$COMPOSE_DIR"
docker compose up -d
log "Done."

log "Waiting for containers to be healthy..."
TIMEOUT=120
if timeout "$TIMEOUT" bash -c '
    while true; do
        if docker compose ps --format json | jq -e "select(.Health != \"\" and .Health != \"healthy\")" > /dev/null 2>&1; then
            sleep 5
        else
            break
        fi
    done
'; then
    log "All containers healthy."
else
    log "ERROR: Containers not healthy after ${TIMEOUT}s"
    docker compose ps
    exit 1
fi

docker compose ps