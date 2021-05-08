#!/bin/bash
## /root/.cron-scripts/backup-mariadb-monthly.sh
## Backup all databases on local mariaDB
## This script is meant to be run by a cronjob.
## @monthly /root/.cron-scripts/backup-mariadb-monthly.sh
##
## See also (related reading):
## https://man7.org/linux/man-pages/man1/date.1.html

BACKUPS_DIR="/media/somedrive/mysql-simple-backups"
MYSQL_BACKUP_PASSWORD="PASSWORD-GOES-HERE-REPLACEME"

## Backup the DB
mysqldump -h"localhost" -u"backups" -p"${MYSQL_BACKUP_PASSWORD}" --tz-utc --quick --opt --single-transaction --skip-lock-tables --all-databases | gzip > "${BACKUPS_DIR}/all_dbs-monthly-$(date -u +%b).sql.gz"
