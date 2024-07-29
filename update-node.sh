#!/bin/bash

cd ~
rm -r 0g-storage-node
git clone https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git stash
git tag -d v0.3.4
git fetch --all --tags
git checkout 7d73ccd
git submodule update --init
cargo build --release
