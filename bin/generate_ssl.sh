#!/bin/sh
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./nginx/etc/localhost.key -out ./nginx/etc/localhost.crt
