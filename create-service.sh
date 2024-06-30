#!/bin/bash

sudo tee /etc/systemd/system/0g-storage.service > /dev/null <<EOF
[Unit]
Description=0g storage node
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
WorkingDirectory=/root/0g-storage-node/run
ExecStart=/root/0g-storage-node/target/release/zgs_node --config config.toml
Restart=always
RestartSec=30
[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/0g-storage-kv.service > /dev/null <<EOF
[Unit]
Description=0g storage kv
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
WorkingDirectory=/root/0g-storage-kv/run
ExecStart=/root/0g-storage-kv/target/release/zgs_kv --config config.toml
Restart=always
RestartSec=30
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable 0g-storage
sudo systemctl enable 0g-storage-kv

echo "Service created, start with start-service.sh"
