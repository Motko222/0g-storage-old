#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

systemctl stop $folder.service
systemctl disable $folder.service
rm /etc/systemd/system/$folder.service
rm -r /root/0g-storage-node/run/db
rm -r /root/0g-storage-node/run/log
rm -r /root/backup/0g-storage-node 
mv -f /root/0g-storage-node /root/backup
rm -r /root/backup/scripts/0g-storage 
mv -f /root/scripts/$folder /root/backup/scripts
