#!/bin/bash

read -p "Tag ? (https://github.com/0glabs/0g-storage-kv/releases) " tag

#backup config files
[ -d ~/backup ] || mkdir ~/backup
[ -d ~/backup/0g-storage-kv ] || mkdir ~/backup/0g-storage-kv
cp ~/0g-storage-kv/run/config.toml ~/backup/0g-storage-kv/config.toml
cp ~/0g-storage-kv/run/log_config ~/backup/0g-storage-kv/log_config

#deploy
cd ~
rm -r 0g-storage-kv
git clone -b $tag https://github.com/0glabs/0g-storage-kv.git
cd 0g-storage-kv
git submodule update --init
cargo build --release

#restore config files
cp ~/backup/0g-storage-kv/config.toml ~/0g-storage-kv/run/config.toml
cp ~/backup/0g-storage-kv/log_config ~/0g-storage-kv/run/log_config

#save version
echo $tag >/root/logs/da-node-version
