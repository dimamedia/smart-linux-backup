#!/bin/bash

date=`date "+%Y-%m-%d"`
bkpPath=/backup

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

echo -e "\n--- Backuping Databases ---\n";


user=backup
pass=B4k4pp1_
sqlPath=$bkpPath/hez-backup/mysql_bkp
#mkdir $sqlPath

echo -e "\t--- ecotoimistotarvike";
mysqldump --opt --user=$user --password=$pass ecotoimistotarvike > $sqlPath/ecotoimistotarvike_$date.sql
echo -e "\t--- proficient";
mysqldump --opt --user=$user --password=$pass proficient > $sqlPath/proficient_$date.sql
echo -e "\t--- kassakaappi";
mysqldump --opt --user=$user --password=$pass kassakaappi > $sqlPath/kassakaappi_$date.sql
echo -e "\t--- tyotuolikeskus";
mysqldump --opt --user=$user --password=$pass tyotuolikeskus > $sqlPath/tyotuolikeskus_$date.sql
echo -e "\t--- ergonea";
mysqldump --opt --user=$user --password=$pass ergonea > $sqlPath/ergonea_$date.sql



