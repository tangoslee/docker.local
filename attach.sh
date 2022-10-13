#!/bin/bash
# https://opensource.com/article/19/9/linux-terminal-colors

CONTAINER=php
OPT="-it"

[ "$1" != "" ] && CONTAINER="$1"
[ "$2" != "" ] && OPT="$OPT --user $2"

docker exec -it $OPT $CONTAINER /bin/bash --init-file ~/.bashrc_docker
