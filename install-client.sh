#!/bin/bash

read -p "Sure? " yn
case $yn in
 y|Y|yes|Yes|YES) ;;
 *) exit ;;
esac

cd ~
rm -r 0g-storage-client
git clone https://github.com/0glabs/0g-storage-client.git
cd 0g-storage-client
go build


