#!/bin/bash

source ~/scripts/0G-chain/cfg
source ~/.bash_profile

#get RPC addresses
node_rpc=$(cat ~/0g-storage-node/run/config.toml | grep "rpc_listen_address =" | tail -1 | awk '{print $3}' | sed 's/"//g')
chain_rpc=$(cat ~/0g-storage-node/run/config.toml | grep "blockchain_rpc_endpoint =" | tail -1 | awk '{print $3}' | sed 's/"//g')

#get version
cd ~/0g-storage-node/target/release
node_version=$(./zgs_node --version | awk '{print $2}')

#get storage node info
json=$(curl -sX POST $node_rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}')
node_height=$(echo $json | jq -r .result.logSyncHeight)
peers=$(echo $json | jq -r .result.connectedPeers)

#get chain info
chain_height=$((16#$(curl -s -X POST $chain_rpc  -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r  .result | sed 's/0x//g')))

cat << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "id":"$ID",
  "machine":"$MACHINE",
  "node rpc":"$node_rpc",
  "node version":"$node_version",
  "node height":"$node_height",
  "node peers":"$peers",
  "chain rpc":"$chain_rpc",
  "chain height":"$chain_height"
}
EOF

