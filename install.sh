#!/bin/bash

read -p "Sure? " yn
case $yn in
 n|N|no|No|NO) exit ;;
esac

#update
sudo apt-get update
sudo apt-get install clang cmake build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#install go
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

#backup config files
[ -d ~/backup ] mkdir ~/backup
[ -d ~/backup/0g-storage-kv ] mkdir ~/backup/0g-storage-kv
[ -d ~/backup/0g-storage-node ] mkdir ~/backup/0g-storage-node
cp ~/0g-storage-node/run/config.toml ~/backup/0g-storage-node/config.toml
cp ~/0g-storage-node/run/log_config ~/backup/0g-storage-node/log_config
cp ~/0g-storage-kv/run/config.toml ~/backup/0g-storage-kv/config.toml
cp ~/0g-storage-kv/run/log_config ~/backup/0g-storage-kv/log_config

cd ~
rm 0g-storage-node
git clone -b v0.3.4 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
cargo build --release

cd ~
rm 0g-storage-kv
git clone -b v1.1.0-testnet https://github.com/0glabs/0g-storage-kv.git
cd 0g-storage-kv
git submodule update --init
cargo build --release

cd ~
git clone https://github.com/0glabs/0g-storage-client.git
cd 0g-storage-client
go build

#restore config files
cp ~/backup/0g-storage-node/config.toml ~/0g-storage-node/run/config.toml
cp ~/backup/0g-storage-node/log_config ~/0g-storage-node/run/log_config
cp ~/backup/0g-storage-kv/config.toml ~/0g-storage-kv/run/config.toml
cp ~/backup/0g-storage-kv/log_config ~/0g-storage-kv/run/log_config
