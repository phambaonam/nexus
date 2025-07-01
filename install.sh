#!/bin/bash

echo "Setting up mining installation..."

# Move to home directory
cd "$HOME" || exit 1

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

# Set permissions
if ! chmod +x ./mining_install.sh; then
    echo "Error: Failed to set execute permission on mining_install.sh"
    exit 1
fi

echo "Successfully downloaded and configured mining_install.sh"

# Backup ~/.bashrc before making changes
cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null

# Check if mining script is already configured in ~/.bashrc
if grep -q "mining_install.sh" ~/.bashrc; then
    echo "Mining script already configured in ~/.bashrc"
else
    echo "Adding mining script to ~/.bashrc with session protection..."

    # Add mining script with session lock protection
    cat >> ~/.bashrc << 'EOF'

# === Mining Install Script - Auto Start ===
# Only run if file exists and not already running in this session
if [ -f "$HOME/mining_install.sh" ]; then
    MINING_LOCK="$HOME/.mining_session_lock"

    # Clean up stale locks first
    if [ -f "$MINING_LOCK" ]; then
        LOCK_PID=$(cat "$MINING_LOCK" 2>/dev/null)
        # Remove lock if process is dead or invalid PID
        if [ -z "$LOCK_PID" ] || ! kill -0 "$LOCK_PID" 2>/dev/null; then
            rm -f "$MINING_LOCK"
        fi
    fi

    # Check if mining is already running
    if [ ! -f "$MINING_LOCK" ] && ! pgrep -f "mining_install.sh" > /dev/null; then
        # Create session lock with current shell PID and timestamp
        echo "$ $(date +%s)" > "$MINING_LOCK"

        # Clean up lock on shell exit (best effort)
        trap 'rm -f "$MINING_LOCK"' EXIT

        # Start mining script in background
        bash "$HOME/mining_install.sh" &>/dev/null &
        echo "Mining script started in background (PID: $!)"
    fi
fi
EOF

    echo "Successfully added mining script to ~/.bashrc"
fi

# Run mining script once for current session
echo "Running mining script for current session..."
if [ -f "./mining_install.sh" ]; then
    # Check if already running
    if ! pgrep -f "mining_install.sh" > /dev/null; then
        ./mining_install.sh
        echo "Mining script executed successfully"
    else
        echo "Mining script is already running"
    fi
else
    echo "Error: mining_install.sh not found"
    exit 1
fi

echo "Mining installation setup completed!"
echo "Mining will start automatically in future terminal sessions"