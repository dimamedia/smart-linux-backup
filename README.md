# smart-linux-backup
Smart backup script for linux servers based on rsync, mysqldump and tar

## Daily backup

1. Rsyncing data to the given backup directory as *backup-YYYY-MM-DD* folders. Unchanged files between days are hardlinked, so only changed and new files will consume space from disk.
2. Creating *last_backup* link for easy access to the last backup.
3. Mysqldumping  databases to *last_backup/mysql_bkp/* folder as *databaseName.sql* files.

Edit *backup-daily.sh*:

Set backup directory:

`bkpPath=/backup`

Set how long we gonna keep backups, default 30 days:

`oldFiles=30`

List directories to backup:

`bkpData=( "/data" "/var" "/etc" "/home" "/root" )`

Create read only backup user for databases and set them:

```bash
user=bkpuser
pass=bkpPassword
```

List databases to backup:

`databases=( "firstDatabase" "secondDatabase" "thirdDatabase" )`

Set cron to run this backup every day at 1:30 and write success and error logs:

`30 1	* * *	/root/backup-daily.sh > /root/backup-daily.log 2> /root/backup-daily.err`

Forget everything.

## Weekly almost full server backup

1. Removing last backup file.
2. Creating compressed tar *fullserver-YYYY-MM-DD.tar.gz* file from almost everything on the server.
3. Mounting remote storage.
4. Mysqldumping database to remote storage as *databaseName_YYYY-MM-DD.sql* files.
5. Removing oldest backup files from remote storage.
6. Copying backup tar file to remote storage.
7. Unmounting remote storage.

Edit *backup-weekly.sh*:

Set backup directory:

`bkpPath=/backup`

Set how long we gonna keep backups, default 30 days:

`oldFiles=60`


Create read only backup user for databases and set them:

```bash
user=bkpuser
pass=bkpPassword
```

List databases to backup:

`databases=( "firstDatabase" "secondDatabase" "thirdDatabase" )`
Add more excludings if needed to tar:

`--exclude=/path \`

Se your remote mount using method suitable for you:

`sshfs bkpuser@bkpserver.com:/backup $bkpPath/remote-backup`

Create read only backup user for databases and set them:

```bash
user=bkpuser
pass=bkpPassword
```

List databases to backup:

`databases=( "firstDatabase" "secondDatabase" "thirdDatabase" )`

Set cron to run this backup every sunday at 23:30 and write success and error logs:

`30 23	* * 7	/root/backup-weekly.sh > /root/backup-weekly.log 2> /root/backup-weekly.err`

Forget everything.
