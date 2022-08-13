#!/bin/bash
# https://opensource.com/article/19/9/linux-terminal-colors

CONTAINER=workspace

[ "$1" != "" ] && CONTAINER=$1

docker exec -it $CONTAINER /bin/bash --init-file ~/.bashrc_docker
