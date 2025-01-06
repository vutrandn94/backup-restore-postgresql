# backup-restore-postgresql
Backup &amp; Restore PostgreSQL

*Backup will be stored in folder with format "%d%m%Y"*

## Detailed information of variables

| Variable | Describe |
| :--- | :--- |
| PGUSER | PostgreSQL login user (Default: root) |
| PGPASSWORD | PostgreSQL password login user |
| PGPORT | PostgreSQL port connection (Default: 5432) |
| PGHOST | PostgreSQL host connection (Default: localhost) |
| DB_EXCLUDE | Exclude database backups |
| BACKUP_FOLDER | Folder storage backups |
| ROTATE_KEEP | Specify the number of backup copies to keep (Default: 7)|
| BACKUP_DIR | Exact path to the folder storing the backup files in (.sql) format that need to be restored |
