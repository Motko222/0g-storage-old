#!/bin/bash

sudo journalctl -u 0g-storage-kv.service -f --no-hostname -o cat
