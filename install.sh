#!/bin/bash

# Clean up old file
rm -rf mining_install.sh

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