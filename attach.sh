#!/bin/bash
# https://opensource.com/article/19/9/linux-terminal-colors

CONTAINER=php
USER=""

[ "$1" != "" ] && CONTAINER="$1"
[ "$2" != "" ] && USER="--user $2"

docker exec -it $USER $CONTAINER /bin/bash --init-file ~/.bashrc_docker
