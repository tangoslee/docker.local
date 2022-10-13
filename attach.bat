@echo off
SETLOCAL EnableDelayedExpansion

if "%1" == "" (
	SET CONTAINER="php"
) else (
	SET CONTAINER="%1"
)

if "%2" == "" (
	docker exec -it %CONTAINER% /bin/bash --init-file ~/.bashrc_docker
) else (
	SET USER="--user %2"
	docker exec -it %USER% %CONTAINER% /bin/bash --init-file ~/.bashrc_docker
)
