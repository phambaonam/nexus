#!/bin/bash

# Clean up old file
rm -rf mining_install.sh
rm -rf /home/user/.nexus

# stop services restart
sudo systemctl stop startup_nexus.service 2>/dev/null || true
sudo systemctl stop startup_nexus2.service 2>/dev/null || true
sudo systemctl stop startup_nexus3.service 2>/dev/null || true

# Install nexus
sudo apt update
sudo apt install screen curl build-essential pkg-config libssl-dev git-all -y
sudo apt install protobuf-compiler

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

curl -sSf https://cli.nexus.xyz/ -o install_nexus.sh \
  && chmod +x install_nexus.sh \
  && NONINTERACTIVE=1 ./install_nexus.sh

source ~/.bashrc

# Check if startup_nexus scripts are already configured in ~/.bashrc
echo "Checking startup_nexus configuration in ~/.bashrc..."
if grep -q "startup_nexus_1.sh" ~/.bashrc && grep -q "startup_nexus_2.sh" ~/.bashrc && grep -q "startup_nexus_3.sh" ~/.bashrc; then
    echo "Startup_nexus scripts already configured in ~/.bashrc"
else
    echo "Adding startup_nexus scripts to ~/.bashrc..."

    cat >> ~/.bashrc << 'EOF'

# === Startup Nexus Scripts - Auto Start ===
bash "$HOME/startup_nexus_1.sh" &>/dev/null &
bash "$HOME/startup_nexus_2.sh" &>/dev/null &
bash "$HOME/startup_nexus_3.sh" &>/dev/null &
EOF

    echo "Successfully added startup_nexus scripts to ~/.bashrc"
fi

LINE_SKIP='bash "$HOME/startup_nexus_3.sh" &>/dev/null &'

if grep -Fxq "$LINE_SKIP" ~/.bashrc; then
    sed -i "s/^bash \"\$HOME\/startup_nexus_3\.sh\" \&>\/dev\/null \&$/#&/" ~/.bashrc
    echo "commented"
else
    echo "Not exist or commented"
fi

exit 0