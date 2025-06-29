#!/bin/bash

# Install Dependencies
sudo apt update
sudo apt install screen curl build-essential pkg-config libssl-dev git-all -y
sudo apt install protobuf-compiler -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
# rustup target add riscv32i-unknown-none-elf

curl -sSf https://cli.nexus.xyz/ -o install_nexus.sh \
  && chmod +x install_nexus.sh \
  && NONINTERACTIVE=1 ./install_nexus.sh

source ~/.bashrc