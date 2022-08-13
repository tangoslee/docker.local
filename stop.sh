#!/bin/bash
docker-compose down && {
	sudo systemctl stop docker.socket &&
  sudo systemctl stop docker
} && {
sudo systemctl disable docker
}
