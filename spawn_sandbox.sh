#!/usr/bin/env bash
set -euo pipefail

PRJ_NAME="sandbox"
PRJ_DIR="$(pwd)"
CONTAINER_IMAGE=""
ATTACH=false
STOP=false
COMPOSE_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
    cat <<EOF
Usage: $0 [options]

Spawn a Docker sandbox container.

Options:
    --prj-name <name>   Project name (default: $PRJ_NAME)
    --prj-dir <dir>     Project directory (default: current directory)
    --image <image>     Docker image to use (default: image defined in docker-compose.yml)
    --attach            Attach to an existing container instead of creating a new one
    --stop              Stop and remove the container
    --help, -h          Show this help message and exit
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --prj-name)
            PRJ_NAME="$2"
            shift 2
            ;;
        --prj-dir)
            PRJ_DIR="$2"
            shift 2
            ;;
        --image)
            CONTAINER_IMAGE="$2"
            shift 2
            ;;
        --attach)
            ATTACH=true
            shift
            ;;
        --stop)
            STOP=true
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            usage >&2
            exit 1
            ;;
    esac
done

if [ "$STOP" = true ]; then
    export PRJ_NAME
    export CONTAINER_IMAGE
    exec docker compose -p "$PRJ_NAME" -f "$COMPOSE_DIR/docker-compose.yml" down
fi

if [ ! -d "$PRJ_DIR" ]; then
    echo "Error: project directory '$PRJ_DIR' not found" >&2
    exit 1
fi

export PRJ_NAME
export PRJ_DIR
export CONTAINER_IMAGE

container_running() {
    docker ps --format '{{.Names}}' | grep -qxF "$PRJ_NAME"
}

container_exists() {
    docker ps -a --format '{{.Names}}' | grep -qxF "$PRJ_NAME"
}

start_container() {
    docker compose -p "$PRJ_NAME" -f "$COMPOSE_DIR/docker-compose.yml" up -d
}

exec_container() {
    docker compose -p "$PRJ_NAME" -f "$COMPOSE_DIR/docker-compose.yml" exec dev bash
}

if [ "$ATTACH" = true ]; then
    if ! container_exists; then
        start_container
    elif ! container_running; then
        docker start "$PRJ_NAME"
    fi
    exec_container
else
    start_container
    exec_container
    echo "Stopping container..."
    docker compose -p "$PRJ_NAME" -f "$COMPOSE_DIR/docker-compose.yml" down
fi
