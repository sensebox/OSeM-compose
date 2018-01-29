#!/bin/bash

set -euo pipefail

volumes="userimages,caddy-data,frontend-assets,mongo-data"

IFS=$','
for volume_name in $volumes; do
  echo -n "Creating docker volume "
  docker volume create -d local "$volume_name"
  echo "done"
done
