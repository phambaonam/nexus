#!/bin/bash

sed -i '/# Install Dependencies/d' startup_nexus_1.sh 2>/dev/null
sed -i '/sudo apt update/d' startup_nexus_1.sh 2>/dev/null
sed -i '/sudo apt install screen curl build-essential/d' startup_nexus_1.sh 2>/dev/null
sed -i '/sudo apt install protobuf-compiler/d' startup_nexus_1.sh 2>/dev/null
sed -i '/curl --proto.*rustup.rs/d' startup_nexus_1.sh 2>/dev/null
sed -i '/source \$HOME\/.cargo\/env/d' startup_nexus_1.sh 2>/dev/null
sed -i '/curl -sSf https:\/\/cli.nexus.xyz/d' startup_nexus_1.sh 2>/dev/null
sed -i '/chmod +x install_nexus.sh/d' startup_nexus_1.sh 2>/dev/null
sed -i '/NONINTERACTIVE=1 \.\/install_nexus.sh/d' startup_nexus_1.sh 2>/dev/null
sed -i '/source ~\/.bashrc/d' startup_nexus_1.sh 2>/dev/null
sed -i '/rustup target add riscv32i-unknown-none-elf/d' startup_nexus_1.sh 2>/dev/null

sed -i '/bash "\$HOME\/startup_nexus_1\.sh" &>\/dev\/null &/d' ~/.bashrc 2>/dev/null
sed -i '/bash "\$HOME\/startup_nexus_2\.sh" &>\/dev\/null &/d' ~/.bashrc 2>/dev/null
sed -i '/bash "\$HOME\/startup_nexus_3\.sh" &>\/dev\/null &/d' ~/.bashrc 2>/dev/null
echo "Edited file startup_nexus_1.sh"

# Install Dependencies
sudo apt update
sudo apt install screen curl build-essential pkg-config libssl-dev git-all xdotool -y
sudo apt install protobuf-compiler -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
# rustup target add riscv32i-unknown-none-elf

curl -sSf https://cli.nexus.xyz/ -o install_nexus.sh \
  && chmod +x install_nexus.sh \
  && NONINTERACTIVE=1 ./install_nexus.sh

source ~/.bashrc

curl -sSL https://raw.githubusercontent.com/phambaonam/nexus/main/startup_nexus_service.sh | bash
curl -sSL https://raw.githubusercontent.com/phambaonam/nexus/main/nexus_log_monitor.sh | bash &
# curl -sSL https://raw.githubusercontent.com/phambaonam/nexus/main/install.sh | bash

# --- start Nexus ---
[ -f "$HOME/startup_nexus_1.sh" ] && bash "$HOME/startup_nexus_1.sh" &>/dev/null &
[ -f "$HOME/startup_nexus_2.sh" ] && bash "$HOME/startup_nexus_2.sh" &>/dev/null &
[ -f "$HOME/startup_nexus_3.sh" ] && bash "$HOME/startup_nexus_3.sh" &>/dev/null &