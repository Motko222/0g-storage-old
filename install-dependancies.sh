#!/bin/bash

#update
sudo apt-get update
sudo apt-get install clang cmake build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#install go
cd ~
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
rm go1.22.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
