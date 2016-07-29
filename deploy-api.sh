#!/bin/bash

docker-compose pull api && docker-compose up -d --force-recreate --remove-orphans api
