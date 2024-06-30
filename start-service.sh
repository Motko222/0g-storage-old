#!/bin/bash
 
sudo systemctl restart 0g-storage
tail -n 100 -f $(find ~/0g-storage-node/run/log -type f -exec ls -t1 {} + | head -1)
