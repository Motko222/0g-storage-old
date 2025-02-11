#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $(cd $path | awk -F/ '{print $NF}'))

#read storage servers from indexer setup file
cd $path
storage=$(cat indexer)

#stop
kill -9 $(ps aux | grep -v grep | grep indexer | awk '{print $2}')

#start indexer
cd /root/0g-storage-client
./0g-storage-client indexer --endpoint :12345 --trusted $storage &>~/logs/0g-indexer &
