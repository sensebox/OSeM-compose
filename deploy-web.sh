#!/bin/bash

docker-compose pull osem-static && docker-compose rm -fv osem-static && docker-compose up -d --force-recreate --remove-orphans osem-static web
