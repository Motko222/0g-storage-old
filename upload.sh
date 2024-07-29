#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
#contract=0x8873cc79c5b3b5666535C825205C9a128B1D75F1
contract=0xB7e39604f47c0e4a6Ad092a281c1A8429c2440d3

source ~/scripts/0g-chain/cfg
source ~/.bash_profile

read -p "Key? ($KEY) " key
[ -z $key ] && key=$KEY

pk=$({ echo y; sleep 1; echo $PASS; } |  $BINARY keys unsafe-export-eth-key $key)

file=~/logs/0g-upload-file
echo $(openssl rand -base64 $(( $RANDOM % 40 + 10 )) ) > $file

echo wallet: $(echo "0x$(0gchaind debug addr $(echo $PASS | 0gchaind keys show $KEY -a) | grep hex | awk '{print $3}')")
echo pk: $pk
echo chain rpc: $CHAIN_RPC
echo storage rpc: $STORAGE_RPC
echo contract: $contract

cd ~/0g-storage-client
./0g-storage-client upload --url $CHAIN_RPC --contract $contract  \
  --key $pk --node $STORAGE_RPC --file $file
