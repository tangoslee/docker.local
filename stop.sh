#!/bin/bash
CFG=$(./config.sh)
docker-compose $CFG down && {
	sudo systemctl stop docker.socket &&
  sudo systemctl stop docker
} && {
sudo systemctl disable docker
}
