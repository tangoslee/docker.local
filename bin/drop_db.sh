#!/bin/bash
# https://dev.mysql.com/doc/refman/8.0/en/creating-accounts.html
__DIR__=$(dirname $(readlink -f $0))

config=$__DIR__/../.env

DBNAME="$1"

[ "$DBNAME" = "" ] && {
  echo "usage: `basename $0` dbname"
  exit 1
}

echo "Drop database $DBNAME"

#CMD="mysql -h db.localhost -u root -p$PASS mysql"
CMD="mysql -h db.localhost -u root mysql"
TMP=.user.sql

[ -f "$TMP" ] && rm -f "$TMP"

cat<<EOL > $TMP
DROP DATABASE IF EXISTS $DBNAME;
EOL

{
  $CMD < "$TMP" 
} && {
  [ -f "$TMP" ] && rm -f "$TMP"
}

