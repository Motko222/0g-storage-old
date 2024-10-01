#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile
source ~/scripts/0g-chain/cfg

#generic
network=testnet
chain=newton

#get folder size
folder_size=$(du -hs -L ~/0g-storage-node | awk '{print $1}')

#get RPC addresses
node_rpc=$(cat ~/0g-storage-node/run/config.toml | grep '^rpc_listen_address =' | tail -1 | awk '{print $3}' | sed 's/"//g')
chain_rpc=$(cat ~/0g-storage-node/run/config.toml | grep '^blockchain_rpc_endpoint =' | tail -1 | awk '{print $3}' | sed 's/"//g')
kv_rpc=$(cat ~/0g-storage-kv/run/config.toml | grep '^rpc_listen_address =' | tail -1 | awk '{print $3}' | sed 's/"//g')

#get storage node info
cd ~/0g-storage-node/target/release
node_version=$(./zgs_node --version | awk '{print $2}')
json1=$(curl -sX POST $node_rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}')
node_height=$(echo $json1 | jq -r .result.logSyncHeight)
peers=$(echo $json1 | jq -r .result.connectedPeers)

#get kv info
kv_result=$(curl -sX POST $kv_rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"kv_getStatus","params":[],"id":1}'  | jq .result)
cd ~/0g-storage-kv/target/release
kv_version=$(./zgs_kv --version | awk '{print $2}')

#get chain info
chain_height=$((16#$(curl -s -X POST $chain_rpc  -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r  .result | sed 's/0x//g')))

block_diff=$(( $chain_height - $node_height ))
announce=$(cat ~/0g-storage-node/run/log/zgs* | grep -a "file announcement addr" | tail -1 | awk -F "addr=" '{print $NF}' | sed 's/\"//g")
listen=$(cat ~/0g-storage-node/run/log/zgs* | grep -a "Listening established address=" | tail -1 | awk -F "address=" '{print $NF}')


cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
     "id":"$ID",
     "machine":"$MACHINE",
     "grp":"storage",
     "owner":"$OWNER"
  },
  "fields": {
    "folder_size":"$folder_size",
    "node_rpc":"$node_rpc",
    "node_version":"$node_version",
    "node_height":"$node_height",
    "peers":"$peers",
    "announce":"$announce",
    "listen":"$listen",
    "chain_rpc":"$chain_rpc",
    "chain_height":"$chain_height",
    "block_diff":"$block_diff",
    "kv_rpc":"$kv_rpc",
    "kv_result":"$kv_result",
    "kv_version":"$kv_version"
  }
}
EOF

cat $json
