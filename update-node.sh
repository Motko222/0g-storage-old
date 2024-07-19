#!/bin/bash

cd ~/0g-storage-node
git stash
git tag -d v0.3.4
git fetch --all --tags
git checkout 5b6a4c716174b4af1635bfe903cd4f82894e0533
git submodule update --init
cargo build --release
