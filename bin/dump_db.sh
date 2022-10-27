#!/bin/sh
#It is best that --tab be used only for dumping a local server. If you use it with a remote server, the --tab directory must exist on both the local and remote hosts, and the .txt files are written by the server in the remote directory (on the server host), whereas the .sql files are written by mysqldump in the local directory (on the client host).
# https://dev.mysql.com/doc/refman/8.0/en/mysqldump-delimited-text.html
CWD=$(dirname $(readlink -f "$0"))
ENV=${CWD}/../.env

[ -f "$ENV" ] && {
. "$ENV"
}


DATABASE="$1"
CMD="docker exec mysql"

[ "$DATABASE" = "" ] && {
cat<<EOL
usage: $(basename $0) database_to_restore
EOL
exit 1
}

SECURE_DIR=$($CMD mysql -N -e "SHOW VARIABLES LIKE 'secure_file_priv';" | awk '{ print $2 }')
[ "$SECURE_DIR" = "" ] && SECURE_DIR=/var/lib/mysql-files

[ -d "${DB_DUMP_DIR}" ] &&
{
  echo "Cleaning ${DB_DUMP_DIR} before dump"
  find "${DB_DUMP_DIR}" -type f -exec rm -f {} \;
} && {
  echo "Dump Started to ${DB_DUMP_DIR}"
  $CMD mysqldump -u root "$DATABASE" --tab=$SECURE_DIR --fields-terminated-by=0x1e  --single-transaction --order-by-primary
} && {
  echo "The job has been successfully done!"
}


