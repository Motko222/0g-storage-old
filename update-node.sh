#!/bin/bash

read -p "tag? (https://github.com/0glabs/0g-storage-node/releases) " tag

cd ~/0g-storage-node
git stash
git tag -d $tag
git fetch --all --tags
git checkout 5b6a4c716174b4af1635bfe903cd4f82894e0533
git submodule update --init
cargo build --release
