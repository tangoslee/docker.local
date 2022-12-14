#!/bin/bash
# https://dev.mysql.com/doc/refman/8.0/en/creating-accounts.html

uname -a | grep Darwin > /dev/null
if [ $? -eq 0 ]; then
  #Mac
  [ -f /usr/local/bin/grealpath ] || {
    echo "grealpath not found"
    echo "brew install coreutils"
    exit 1;
  }
  CWD=$(dirname $(grealpath "$0"))
else
  #Ubuntu
  CWD=$(dirname $(readlink -f "$0"))
fi
ENV=${CWD}/../.env

[ -f "$ENV" ] && {
. "$ENV"
}

DBNAME="$1"

[ "$DBNAME" = "" ] && {
  echo "usage: $(basename "$0") dbname"
  exit 1
}
#export MYSQL_PWD="$DB_PASSWORD"

echo "Create database $DBNAME"

HOST="%"
USER=${DB_USERNAME}
PASS=${DB_PASSWORD}

[ "$USER" = "" -o "$PASS" = "" ] && {
  echo "Invalid format:  user or password"
  exit
}

CMD="mysql -h db.localhost -u root mysql"
TMP=.user.sql

[ -f "$TMP" ] && rm -f "$TMP"

cat<<EOL > $TMP
CREATE DATABASE IF NOT EXISTS $DBNAME;
CREATE USER IF NOT EXISTS '$USER'@'$HOST' IDENTIFIED BY '$PASS';
GRANT ALL ON $DBNAME.* TO '$USER'@'$HOST';
FLUSH PRIVILEGES;
EOL

{
  $CMD < "$TMP"
} && {
  [ -f "$TMP" ] && rm -f "$TMP"
} && {
  echo "$DBNAME has been successfully created"
}

