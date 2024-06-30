#!/bin/bash

tail -n 100 -f $(find ~/0g-storage-kv/run/log -type f -exec ls -t1 {} + | head -1)
