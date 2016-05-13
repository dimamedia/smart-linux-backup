# smart-linux-backup
Smart backup script for linux servers based on rsync, mysqldump and tar

## Daily backup
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




**Crontab** every day at 1:30

`30 1	* * *	/root/backup-daily.sh > /root/backup-daily.log 2> /root/backup-daily.err`

