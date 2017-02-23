#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

service=${1:-}
if [[ -z "$service" ]]; then
    echo "usage: $0 service-name"
    exit 1
fi

docker-compose pull "$service"
docker-compose up -d --force-recreate --remove-orphans "$service"
