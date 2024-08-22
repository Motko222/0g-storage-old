#!/bin/bash

source ~/scripts/0g-chain/cfg
source ~/.bash_profile

#generic
grp=storage
network=testnet
chain=newton
id=$ID

#get folder size
folder_size=$(du -hs -L ~/0g-storage-node | awk '{print $1}')

#get RPC addresses
node_rpc=$(cat ~/0g-storage-node/run/config.toml | grep '^rpc_listen_address =' | tail -1 | awk '{print $3}' | sed 's/"//g')
chain_rpc=$(cat ~/0g-storage-node/run/config.toml | grep '^blockchain_rpc_endpoint =' | tail -1 | awk '{print $3}' | sed 's/"//g')
kv_rpc=$(cat ~/0g-storage-kv/run/config.toml | grep '^rpc_listen_address =' | tail -1 | awk '{print $3}' | sed 's/"//g')

#get storage node info
cd ~/0g-storage-node/target/release
node_version=$(./zgs_node --version | awk '{print $2}')
json=$(curl -sX POST $node_rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}')
node_height=$(echo $json | jq -r .result.logSyncHeight)
peers=$(echo $json | jq -r .result.connectedPeers)

#get kv info
kv_result=$(curl -sX POST $kv_rpc -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"kv_getStatus","params":[],"id":1}'  | jq .result)
cd ~/0g-storage-kv/target/release
kv_version=$(./zgs_kv --version | awk '{print $2}')

#get chain info
chain_height=$((16#$(curl -s -X POST $chain_rpc  -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r  .result | sed 's/0x//g')))

block_diff=$(( $chain_height - $node_height ))

cat << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "id":"$ID",
  "machine":"$MACHINE",
  "folder_size":"$folder_size",
  "node_rpc":"$node_rpc",
  "node_version":"$node_version",
  "node_height":"$node_height",
  "peers":"$peers",
  "chain_rpc":"$chain_rpc",
  "chain_height":"$chain_height",
  "block_diff":"$block_diff",
  "kv_rpc":"$kv_rpc",
  "kv_result":"$kv_result",
  "kv_version":"$kv_version"
}
EOF

# send data to influxdb
if [ ! -z $INFLUX_HOST ]
then
 curl --request POST \
 "$INFLUX_HOST/api/v2/write?org=$INFLUX_ORG&bucket=$INFLUX_BUCKET&precision=ns" \
  --header "Authorization: Token $INFLUX_TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary "
    report,machine=$MACHINE,id=$id,grp=$grp,owner=$OWNER status=\"$status\",peers=\"$peers\",message=\"$message\",kv_version=\"$kv_version\",chain_rpc=\"$chain_rpc\",node_version=\"$node_version\",node_rpc=\"$node_rpc\",kv_rpc=\"$kv_rpc\",chain=\"$chain\",chain_height=\"$chain_height\",node_height=\"$node_height\",kv_result=\"$kv_result\",block_diff=\"$block_diff\" $(date +%s%N) 
    "
fi

