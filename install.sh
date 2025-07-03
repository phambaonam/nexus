#!/bin/bash

# Clean up old file
rm -rf mining_install.sh

# stop services restart
sudo systemctl stop startup_nexus.service 2>/dev/null || true
sudo systemctl stop startup_nexus2.service 2>/dev/null || true
sudo systemctl stop startup_nexus3.service 2>/dev/null || true

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