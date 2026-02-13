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

docker compose ps
