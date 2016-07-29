#!/bin/bash

docker rm $(docker ps -a -q)
docker rmi $(docker images -q -f dangling=true)
docker volume rm $(docker volume ls -qf dangling=true)
