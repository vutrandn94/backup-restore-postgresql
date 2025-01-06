#!/bin/bash

BACKUP_DIR="/mnt/backup/06012025"
PGPASSWORD="xxxxxx"
PGPORT="5432"
PGHOST="localhost"
PGUSER="root"

for i in `ls $BACKUP_DIR`
do
	DATABASE_NAME=$(echo $i | awk -F".sql" '{print $1}')
	PGPASSWORD="$PGPASSWORD" psql -h $PGHOST  -U $PGUSER -p $PGPORT -d postgres -c "CREATE DATABASE \"$DATABASE_NAME\";"
	PGPASSWORD="$PGPASSWORD" psql -h $PGHOST  -U $PGUSER -p $PGPORT -d $DATABASE_NAME -f $BACKUP_DIR/$i
done
