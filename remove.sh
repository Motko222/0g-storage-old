#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

#remove services
systemctl stop 0g-storage.service
systemctl disable 0g-storage.service
rm /etc/systemd/system/0g-storage.service
systemctl stop 0g-storage-kv.service
systemctl disable 0g-storage-kv.service
rm /etc/systemd/system/0g-storage-kv.service

#backup config
mkdir /root/backup/0g-storage-node
mv -f /root/0g-storage-node/run/config.toml /root/backup/0g-storage-node
mv -f /root/0g-storage-node/run/log_config /root/backup/0g-storage-node
rm -r /root/0g-storage-node
mkdir /root/backup/0g-storage-kv
mv -f /root/0g-storage-kv/run/config.toml /root/backup/0g-storage-kv
rm -r /root/0g-storage-kv

#backup scripts
rm -r /root/scripts/0g-storage/.git
mv -f /root/scripts/$folder /root/backup/scripts

#remove influx data
#source /root/0g-chain/cfg
#echo $ID | bash /root/scripts/system/influx-delete-id.sh
