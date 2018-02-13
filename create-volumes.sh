#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

volumes=$(docker-compose config --volumes)

for volume_name in $volumes; do
  echo -n "Creating docker volume "
  docker volume create -d local "$volume_name"
  echo "done"
done
