#!/bin/bash

OPT="$1"

# laradock_elasticsearch_1 exited with code 78
#sudo sysctl -w vm.max_map_count=262144
sysctl vm.max_map_count

sudo systemctl start docker.socket && {
  sudo systemctl start docker.service
  docker-compose down
  docker-compose up -d $OPT
} && sudo systemctl status docker.service

#docker-compose up -d "$OPT"
#docker-compose up --build mysql
#docker-compose up -d --no-deps --build mysql
