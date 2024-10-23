#!/bin/bash

#update
sudo apt-get update
sudo apt-get install clang cmake build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#install go
cd $HOME 
ver="1.22.0"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
