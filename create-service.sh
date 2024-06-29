#!/bin/bash

sudo tee /etc/systemd/system/0g-storage.service > /dev/null <<EOF
[Unit]
Description=0g storage node
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=/root/0g-storage-node/target/release/zgs_node --config /root/0g-storage-node/run/config.toml
Restart=always
RestartSec=30
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable 0g-storage

echo "Service created, start with start-service.sh"
