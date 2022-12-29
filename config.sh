#!/bin/sh
for f in `grep -vE '^#' docker-compose.conf`;do echo -n "-f $f "; done
