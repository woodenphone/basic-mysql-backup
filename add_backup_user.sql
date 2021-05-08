/* add_backup_user.sql
 * Description: Create user for backups.
 * By: Ctrl-S
 * Created: 2020-11-17
 * Updated: 2021-05-08
 */

/* Create backup user */
CREATE USER 'backups'@'localhost' IDENTIFIED BY 'PASSWORD-GOES-HERE-REPLACEME';

/* Grant priveleges to backup user */
GRANT SELECT, LOCK TABLES ON *.* to 'backups'@'localhost'; -- Local users: plain "$ mysql" command ($USER@localhost)
--GRANT SELECT, LOCK TABLES  ON *.* to 'backups'@'permitted-origin-domain-name'; -- Remote users: ($USER@$HOSTNAME)
FLUSH PRIVILEGES;
