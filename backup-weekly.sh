#!/bin/bash

# https://github.com/dimamedia/smart-linux-backup

date=`date "+%Y-%m-%d"`
oldFiles=60         # Keep weekly backups for 60 days
bkpPath=/backup     # backup directory

echo -e "=== Weekly (almost)full server backup ===";

echo -e "\n--- Remove last full backup ...";
rm $bkpPath/fullserver-*
echo -e "done.\n";

echo -e "\n--- Backupping to compressed tar ...";
tar -cvpzf $bkpPath/fullserver-$date.tar.gz \
--exclude=/backup \
--exclude=/dev \
--exclude=/lost+found \
--exclude=/media \
--exclude=/mnt \
--exclude=/proc \
--exclude=/run \
--exclude=/sys \
--exclude=/tmp \
--exclude=/var/spool \
/
echo -e "done.\n";

echo -e "\n--- Mounting remote bkp-storage ...";
# Key based login
sshfs bkpuser@bkpserver.com:/backup $bkpPath/remote-backup
echo -e "done.\n";

echo -e "\n--- Backuping Databases\n";

user=backupUser         # mysql backup user
pass=backupPassword     # mysql backup user's password
# List all databases you want to backup
databases=( "firstDatabase" "secondDatabase" "thirdDatabase" )

sqlPath=$bkpPath/remote-backup/mysql_bkp

for db in ${databases[@]}
do
        echo -e "\t--- Backuping $db ..."
        mysqldump --opt --user=$user --password=$pass $db > $sqlPath/${db}_$date.sql
done

echo -e "\n--- Deleting over $oldFiles days old full backups from remote bkp-storage ...";
find $bkpPath/remote-backup/fullserver-* -maxdepth 0 -type f -mtime +$oldFiles -exec rm {} \;
echo -e "done.\n";

echo -e "\n--- Moving created backup to remote bkp-storage ...";
cp -v $bkpPath/fullserver-$date.tar.gz $bkpPath/remote-backup
echo -e "done.\n";

echo -e "\n--- Unmounting remote bkp-storage ...";
umount $bkpPath/remote-backup
echo -e "done.\n";

