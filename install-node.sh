#!/bin/bash

read -p "Tag ? (https://github.com/0glabs/0g-storage-node/releases) " tag

#backup config files
[ -d ~/backup ] || mkdir ~/backup
[ -d ~/backup/0g-storage-node ] || mkdir ~/backup/0g-storage-node
cp ~/0g-storage-node/run/config.toml ~/backup/0g-storage-node/config.toml
cp ~/0g-storage-node/run/log_config ~/backup/0g-storage-node/log_config

#deploy
cd ~
rm -r 0g-storage-node
git clone -b $tag https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
cargo build --release

#restore config files
cp ~/backup/0g-storage-node/config.toml ~/0g-storage-node/run/config.toml
cp ~/backup/0g-storage-node/log_config ~/0g-storage-node/run/log_config
