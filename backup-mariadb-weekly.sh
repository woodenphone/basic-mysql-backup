#!/bin/bash
## /root/.cron-scripts/backup-mariadb-weekly.sh
## Backup all databases on local mariaDB
## This script is meant to be run by a cronjob.
## @weekly /root/.cron-scripts/backup-mariadb-weekly.sh
##
## See also (related reading):
## https://man7.org/linux/man-pages/man1/date.1.html

BACKUPS_DIR="/media/somedrive/mysql-simple-backups"
MYSQL_BACKUP_PASSWORD="PASSWORD-GOES-HERE-REPLACEME"

## Retain the previous backup until the next run.
mv -v "${BACKUPS_DIR}/all_dbs-weekly.sql.gz" "${BACKUPS_DIR}/all_dbs-weekly.sql.gz.old"

## Backup the DB
mysqldump -h"localhost" -u"backups" -p"${MYSQL_BACKUP_PASSWORD}" --tz-utc --quick --opt --single-transaction --skip-lock-tables --all-databases | gzip > "${BACKUPS_DIR}/all_dbs-weekly.sql.gz"
