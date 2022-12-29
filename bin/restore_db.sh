#!/bin/bash
#It is best that --tab be used only for dumping a local server. If you use it with a remote server, the --tab directory must exist on both the local and remote hosts, and the .txt files are written by the server in the remote directory (on the server host), whereas the .sql files are written by mysqldump in the local directory (on the client host).
# https://dev.mysql.com/doc/refman/8.0/en/mysqldump-delimited-text.html
CWD=$(dirname $(readlink -f "$0"))
ENV=${CWD}/../.env

[ -f "$ENV" ] && {
. "$ENV"
}

SRC=${DB_DUMP_DIR}
DATABASE="$1"
CMD="docker exec mysql"

[ "$DATABASE" = "" ] && {
cat<<EOL
usage: $(basename "$0") database_to_restore
EOL
exit 1
}

SECURE_DIR=$($CMD mysql -u root -N -e "SHOW VARIABLES LIKE 'secure_file_priv';" | awk '{ print $2 }')
[ "$SECURE_DIR" = "" ] && SECURE_DIR=/var/lib/mysql-files

echo "Start to restore database from ${SRC}";
{
  echo "Drop database: ${DATABASE}"
  $CMD mysql -u root -e "DROP DATABASE IF EXISTS $DATABASE"
} && {
  echo "Create database"
  $CMD mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DATABASE" 2> /dev/null
} && {
  echo "Restore $DATABASE"
  for localTxtFile in "${SRC}"/*.txt; do
    localSqlFile=${localTxtFile/${SRC}/${SECURE_DIR::-1}}
    table=$(basename "${localTxtFile::-4}")
    rows=$(wc -l "${localTxtFile}" | awk '{ print $1 }')
    sqlFile=${localSqlFile/.txt/.sql}
    txtFile=${localTxtFile/${SRC}/${SECURE_DIR::-1}}

    echo "Create table: $table"
    $CMD mysql -u root "${DATABASE}" -e "SET FOREIGN_KEY_CHECKS=0;SET UNIQUE_CHECKS=0;source ${sqlFile};"

    echo -n "Restore data: $table (${rows} rows)"
    startedAt=$(date +%s.%3N)
    $CMD mysql -u root "${DATABASE}" --local-infile=1 -e "SET FOREIGN_KEY_CHECKS=0;SET UNIQUE_CHECKS=0;SET AUTOCOMMIT=0;ALTER TABLE ${table} DISABLE KEYS;LOAD DATA LOCAL INFILE '${txtFile}' INTO TABLE ${table} FIELDS TERMINATED BY 0x1e LINES TERMINATED BY '\n';COMMIT;ALTER TABLE ${table} ENABLE KEYS;"
    endedAt=$(date +%s.%3N)
    time1=$(echo "scale=3; ${endedAt} - ${startedAt}" | bc)
    echo " $time1 sec"
  done

  $CMD mysql -u root "${DATABASE}" -e "SET FOREIGN_KEY_CHECKS=1;SET UNIQUE_CHECKS=1;SET AUTOCOMMIT=1;"
} && {
   echo "The job has been successfully done!"
 }

