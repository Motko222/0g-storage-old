#!/bin/bash
 
sudo systemctl restart 0g-storage-kv
tail -n 100 -f $(find ~/0g-storage-kv/run/log -type f -exec ls -t1 {} + | head -1)
