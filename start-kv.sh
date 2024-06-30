#!/bin/bash
 
sudo systemctl restart 0g-storage-kv
sudo journalctl -u 0g-storage-kv.service -f --no-hostname -o cat
