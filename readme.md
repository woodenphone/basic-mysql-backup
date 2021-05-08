# Simple mysql backups

## MySQL / MariaDB Backup user
It's nice to have a dedicated user for backups.

A script to add such a user account is provided in `add_backup_user.sql`

1. Replace the password in the provided SQL script with one you generated yourself.
This is the line you change:
```
CREATE USER 'backups'@'localhost' IDENTIFIED BY 'PASSWORD-GOES-HERE-REPLACEME';
```

This command will generate a random password if you can't make up your own:
```
$ echo "`tr -dc 'a-f0-9' < /dev/urandom | head -c16`"
```

2. Run the SQL script:
```
$ sudo mysql -u'root' -p < add_backup_user.sql
```

3. Verify user can login
This should produce a file continting the schema definition for all your databases but no rows.
You should be prompted to enter the backup user password when you run this command.
```
$ mysqldump -h"localhost" -u"backups" -p --tz-utc --quick --opt --single-transaction  --skip-lock-tables --no-data --all-databases > "$HOME/backup-user-test.sql"
```

Check the file was created:
```
## Check modifcation date:
$ ls -lah "$HOME/backup-user-test.sql"

## Glance at contents:
$ head -n10 "$HOME/backup-user-test.sql"
```


## Automated backup
This section explains how to do a simple weekly backup of the local mariadb databases using a mysqldump and cron.


1. Replace the passwords in the provided shell scripts with that you created for the backup account.

These are the lines you change:
```
BACKUPS_DIR="/media/somedrive/mysql-simple-backups"
MYSQL_BACKUP_PASSWORD="PASSWORD-GOES-HERE-REPLACEME"
```


1. Put the backup scripts in place
```
$ sudo mkdir -vp /root/.cron-scripts/
$ sudo nano /root/.cron-scripts/backup-mariadb-weekly.sh
$ sudo nano /root/.cron-scripts/backup-mariadb-monthly.sh
```
2. Replace the password in the provided 
Set script files as executable:
```
$ sudo chmod -v +x /root/.cron-scripts/backup-mariadb-weekly.sh
$ sudo chmod -v +x /root/.cron-scripts/backup-mariadb-monthly.sh
```


3. Create the location backups will be put into:
```
## Create backup dir
$ sudo mkdir -vp "/media/somedrive/mysql-simple-backups"
## Set permissions so that non-root users can list dir contents but do nothing else.
$ sudo chown -vR "root:root" "/media/somedrive/mysql-simple-backups"
$ sudo chmod -vR 'u=rwX,g=rwX,o=X' "/media/somedrive/mysql-simple-backups"
```

4. Edit crontab to include a line that regularly runs the backup script

Open crontab for editing:
```
$ sudo crontab -e
```

Lines to add:
```
@weekly /root/.cron-scripts/backup-mariadb-weekly.sh
@monthly /root/.cron-scripts/backup-mariadb-monthly.sh
```

If you want to run the weekly backup script immediately:
```
$ sudo ./root/.cron-scripts/backup-mariadb-weekly.sh
```


## Manual backup
* In thsese examples you will be prompted to enter the backup user's mysql password.

To dump all databases to file:
```
$ mysqldump -h"localhost" -u"backups" -p --tz-utc --quick --opt --single-transaction  --skip-lock-tables --all-databases | gzip > "$HOME/all_dbs-$(hostname)-$(date -u +%Y-%m-%dT%H%M%S%z).sql.gz"
```

To dump a specific database to file (in this case "asagi"):
```
$ mysqldump -h"localhost" -u"backups" -p --tz-utc --quick --opt --single-transaction  --skip-lock-tables "asagi" | gzip > "$HOME/all_dbs-$(hostname)-$(date -u +%Y-%m-%dT%H%M%S%z).sql.gz"
```
