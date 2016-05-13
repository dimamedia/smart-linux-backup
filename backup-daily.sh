#!/bin/bash

bkpPath=/backup         # path to backup directory
oldFiles=30             # delete daily backups older than given days

date=`date "+%Y-%m-%dT%H:%M:%S"`

echo -e "=== Daily backup ===";

# List all directories you want to backup
bkpData=( "/data" "/var" "/etc" "/home" "/root" )

for pth in ${bkpData[@]}
do
        echo -e "\t--- Backuping $pth ---\n";
        rsync -vaPh --link-dest=$bkpPath/last_backup $pth $bkpPath/backup-$date
done

echo -e "\n--- Relinking last_backup ...";
rm -f $bkpPath/last_backup
ln -s $bkpPath/backup-$date $bkpPath/last_backup
echo -e "done.\n";

echo -e "\n--- Backuping Databases\n";

user=backupUser         # mysql backup user
pass=backupPassword     # mysql backup user's password
# List all databases you want to backup
databases=( "firstDatabase" "secondDatabase" "thirdDatabase" )

mkdir $bkpPath/last_backup/mysql_bkp
for db in ${databases[@]}
do
        echo -e "\t--- $db"
        mysqldump --opt --user=$user --password=$pass $db > $bkpPath/last_backup/mysql_bkp/${db}_$date.sql
done

echo -e "\n--- Removing over $oldFiles days old backups ...\n";

find $bkpPath/backup-* -maxdepth 0 -type d -mtime +$oldFiles -exec rm -r {} \;

echo -e "done.";
