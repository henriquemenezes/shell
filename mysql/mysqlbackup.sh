#!/bin/bash

echo "# MySQL Databases Backup"
echo -n Password: 
read -s MYSQL_PASSWORD

MYSQL_USER="root"
OUTPUT_DIR="."
DATABASES=`mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -e "show databases;" | grep -Ev "(Database|information_schema|performance_schema)"`
TIMESTAMP=`date +%Y%m%d_%H%M%S`

mkdir -p $OUTPUT_DIR

for DB in $DATABASES; do
	mysqldump -f --opt -u $MYSQL_USER -p$MYSQL_PASSWORD $DB | gzip > $OUTPUT_DIR/$DB-$TIMESTAMP.gz
done
