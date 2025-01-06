#!/bin/bash

## DEFINE VARIABLE ## 
PGUSER="root"
PGPASSWORD="xxxxxx"
PGPORT="5432"
PGHOST="localhost"
DB_EXCLUDE="^postgres$|^template[0-1]$|^repmgr$"
BACKUP_FOLDER="/mnt/backup"
ROTATE_KEEP="7"

## BACKUP PROCESS ##
## Example:
## for i in $(PGPASSWORD="$PGPASSWORD" psql -h localhost  -U $PGUSER -p $PGPORT -d postgres -t -c "SELECT datname FROM pg_database;" | awk '{print $1}' | grep -Ev "^postgres$|^template[0-1]$|^repmgr$")


echo "============ START BACKUP DATABASE PROCESS ============"
mkdir -p $BACKUP_FOLDER/$(date +'%d%m%Y')

for DBNAME in $(PGPASSWORD="$PGPASSWORD" psql -h $PGHOST  -U $PGUSER -p $PGPORT -d postgres -t -c "SELECT datname FROM pg_database;" | awk '{print $1}' | grep -Ev "$DB_EXCLUDE")
do
  echo "===> $(date) - Start backup for database: $DBNAME "
  echo "===> $(date) - Run backup command: PGPASSWORD=\"**********\" pg_dump -U $PGUSER -h $PGHOST $DBNAME > $BACKUP_FOLDER/$(date +'%d%m%Y')/$DBNAME.sql"
  PGPASSWORD="$PGPASSWORD" pg_dump -U $PGUSER -h $PGHOST $DBNAME > $BACKUP_FOLDER/$(date +'%d%m%Y')/$DBNAME.sql
  
  ## VERIFY BACKUP ## 
  if grep -Eq "^-- PostgreSQL database dump complete$" $BACKUP_FOLDER/$(date +'%d%m%Y')/$DBNAME.sql
  then
    echo "===> $(date) - Verify backup database \"$DBNAME\": database dump COMPLETED"
  else
    echo "===> $(date) - Verify backup database \"$DBNAME\": database dump FAILED"
  fi
  echo -e "\n"
  sleep 1
done


## BACKUP ROTATE ##
echo "============ ROTATE OLD BACKUP (KEEP $ROTATE_KEEP BACKUP VERSIONS) ============"
ROTATE_DATE=$(date +'%d%m%Y' -d "$ROTATE_KEEP days ago")
echo "===> $(date) - Run command: rm -rf $BACKUP_FOLDER/$ROTATE_DATE"
rm -rf $BACKUP_FOLDER/$ROTATE_DATE
