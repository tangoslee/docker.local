#!/bin/bash
# https://dev.mysql.com/doc/refman/8.0/en/creating-accounts.html
__DIR__=$(dirname $(readlink -f $0))

config=$__DIR__/../.env

DBNAME="$1"

[ "$DBNAME" = "" ] && {
  echo "usage: `basename $0` dbname"
  exit 1
}

echo "Create database $DBNAME"

CMD="mysql -h db.local -u root mysql"
TMP=.user.sql

[ -f "$TMP" ] && rm -f "$TMP"

HOST="%"
USER=$(grep DB_USERNAME $config | cut -d'=' -f2)
PASS=$(grep DB_PASSWORD $config | cut -d'=' -f2)

[ "$USER" = "" -o "$PASS" = "" ] && {
  echo "Invalid format:  user or password"
  exit
}

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
}

