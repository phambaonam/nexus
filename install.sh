#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Nexus setup...${NC}"

# Clean up previous files
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
echo -e "${GREEN}Cleaned up previous configurations${NC}"

# Check disk space
AVAILABLE_SPACE=$(df "$HOME" | tail -1 | awk '{print $4}')
if [ "$AVAILABLE_SPACE" -lt 1000000 ]; then  # Less than 1GB
    echo -e "${RED}Warning: Low disk space ($(($AVAILABLE_SPACE/1024))MB available)${NC}"
fi

# Install Dependencies
echo -e "${YELLOW}Installing system dependencies...${NC}"
sudo apt update
sudo apt install screen curl build-essential pkg-config libssl-dev git-all xdotool -y
sudo apt install protobuf-compiler -y

# Install/Update Rust
echo -e "${YELLOW}Installing/Updating Rust...${NC}"
if command -v rustup &> /dev/null; then
    echo -e "${GREEN}Rust already installed, updating...${NC}"
    rustup update
else
    echo -e "${YELLOW}Installing Rust...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source $HOME/.cargo/env

# Install Nexus CLI with better error handling
echo -e "${YELLOW}Installing Nexus CLI...${NC}"
cd "$HOME" || exit 1

# Remove old install script if exists
rm -f install_nexus.sh

# Try downloading with retry
for i in {1..3}; do
    echo -e "${YELLOW}Download attempt $i/3...${NC}"
    if curl -sSf https://cli.nexus.xyz/ -o install_nexus.sh; then
        echo -e "${GREEN}Download successful${NC}"
        break
    else
        echo -e "${RED}Download failed, attempt $i/3${NC}"
        if [ $i -eq 3 ]; then
            echo -e "${RED}Failed to download Nexus installer after 3 attempts${NC}"
            exit 1
        fi
        sleep 2
    fi
done

# Check if file was downloaded successfully
if [ ! -f "install_nexus.sh" ] || [ ! -s "install_nexus.sh" ]; then
    echo -e "${RED}install_nexus.sh was not downloaded or is empty${NC}"
    exit 1
fi

# Make executable and run
chmod +x install_nexus.sh
echo -e "${YELLOW}Running Nexus installer...${NC}"
NONINTERACTIVE=1 ./install_nexus.sh

# Clean up installer
rm -f install_nexus.sh

# Source bashrc
source ~/.bashrc 2>/dev/null

# Start Nexus instances first
echo -e "${YELLOW}Starting Nexus instances...${NC}"
[ -f "$HOME/startup_nexus_1.sh" ] && "$HOME/startup_nexus_1.sh" &>/dev/null &
[ -f "$HOME/startup_nexus_2.sh" ] && "$HOME/startup_nexus_2.sh" &>/dev/null &
[ -f "$HOME/startup_nexus_3.sh" ] && "$HOME/startup_nexus_3.sh" &>/dev/null &

# Wait for Nexus instances to start up
echo -e "${YELLOW}Waiting for Nexus instances to initialize...${NC}"
sleep 60

# Wait for log files to appear (indicates Nexus is running)
echo -e "${YELLOW}Waiting for log files to appear...${NC}"
timeout=300  # 5 minutes timeout
counter=0
while [ $counter -lt $timeout ]; do
    if [ -f "$HOME/nexus_out_1.log" ] || [ -f "$HOME/nexus_err_1.log" ]; then
        echo -e "${GREEN}Nexus instances are running (log files detected)${NC}"
        break
    fi
    sleep 5
    counter=$((counter + 5))
    if [ $((counter % 30)) -eq 0 ]; then
        echo -e "${YELLOW}Still waiting for Nexus to start... (${counter}s)${NC}"
    fi
done

if [ $counter -ge $timeout ]; then
    echo -e "${YELLOW}Timeout waiting for log files, proceeding anyway...${NC}"
fi

# Now run additional scripts after Nexus instances are running
echo -e "${YELLOW}Setting up Nexus services...${NC}"

echo -e "${YELLOW}Running startup_nexus_service.sh...${NC}"
curl -sSL https://raw.githubusercontent.com/phambaonam/nexus/main/startup_nexus_service.sh | bash

echo -e "${YELLOW}Starting log monitor...${NC}"
curl -sSL https://raw.githubusercontent.com/phambaonam/nexus/main/nexus_log_monitor.sh | bash &

echo -e "${GREEN}Nexus setup completed!${NC}"
echo -e "${YELLOW}Check logs with: tail -f ~/nexus_out_1.log${NC}"