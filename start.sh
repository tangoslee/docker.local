#!/bin/bash

OPT="$1"

# laradock_elasticsearch_1 exited with code 78
#sudo sysctl -w vm.max_map_count=262144
sysctl vm.max_map_count

# WARNING overcommit_memory is set to 0! Background save may fail under low memory condition.
# To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or
# run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
sysctl vm.overcommit_memory


sudo systemctl start docker.socket && {
  sudo systemctl start docker.service
  docker-compose down
  docker-compose up -d $OPT
} && sudo systemctl status docker.service

#docker-compose up -d "$OPT"
#docker-compose up --build mysql
#docker-compose up -d --no-deps --build mysql
