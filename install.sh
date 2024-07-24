#!/bin/bash

sudo apt-get update
sudo apt-get install clang cmake build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Download the Go installer
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz

# Extract the archive
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

# Add /usr/local/go/bin to the PATH environment variable by adding the following line to your ~/.profile.
export PATH=$PATH:/usr/local/go/bin

cd ~
git clone -b v0.3.4 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
cargo build --release

cd ~
git clone -b v1.1.0-testnet https://github.com/0glabs/0g-storage-kv.git
cd 0g-storage-kv
git submodule update --init
cargo build --release

cd ~
git clone https://github.com/0glabs/0g-storage-client.git
cd 0g-storage-client
go build
