#!/bin/bash
 
sudo systemctl restart 0g-storage

echo "Service started (CTRL-C to close logs)"
sudo journalctl -u 0g-storage -f --no-hostname -o cat
