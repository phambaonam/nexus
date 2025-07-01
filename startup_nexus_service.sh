#!/bin/bash

USER_NAME="${1:-$(whoami)}"
USER_HOME="/home/$USER_NAME"

echo "Setting up services for user: $USER_NAME"
echo "Home directory: $USER_HOME"

################# startup_nexus.service ########################
if [ -f "$USER_HOME/startup_nexus_1.sh" ]; then
    echo "Found startup_nexus_1.sh - Creating startup_nexus.service..."

    sudo tee /etc/systemd/system/startup_nexus.service > /dev/null << EOF
[Unit]
Description=Auto Start Nexus node
After=network-online.target

[Service]
Type=simple
User=$USER_NAME
ExecStart=/bin/bash -c 'bash $USER_HOME/startup_nexus_1.sh >> $USER_HOME/nexus_out_1.log 2>> $USER_HOME/nexus_err_1.log'
Restart=on-failure
RestartSec=5
# Nếu muốn chỉ restart khi gặp lỗi I/O, bạn có thể dùng:
# RestartPreventExitStatus=0

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable startup_nexus.service
    sudo systemctl restart startup_nexus.service
    echo "startup_nexus.service has been created and started."
else
    echo "startup_nexus_1.sh not found - Skipping startup_nexus.service creation."
fi
############################ END ########################################

################# startup_nexus2.service ########################
if [ -f "$USER_HOME/startup_nexus_2.sh" ]; then
    echo "Found startup_nexus_2.sh - Creating startup_nexus2.service..."
    
    sudo tee /etc/systemd/system/startup_nexus2.service > /dev/null << EOF
[Unit]
Description=Auto Start Nexus2 node
After=network-online.target

[Service]
Type=simple
User=$USER_NAME
ExecStart=/bin/bash -c 'bash $USER_HOME/startup_nexus_2.sh >> $USER_HOME/nexus2_out.log 2>> $USER_HOME/nexus2_err.log'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable startup_nexus2.service
    sudo systemctl start startup_nexus2.service
    echo "startup_nexus2.service has been created and started."
else
    echo "startup_nexus_2.sh not found - Skipping startup_nexus2.service creation."
fi
########################## END ###############################S

################# startup_nexus3.service ########################
if [ -f "$USER_HOME/startup_nexus_3.sh" ]; then
    echo "Found startup_nexus_3.sh - Creating startup_nexus3.service..."
    
    sudo tee /etc/systemd/system/startup_nexus3.service > /dev/null << EOF
[Unit]
Description=Auto Start Nexus3 node
After=network-online.target

[Service]
Type=simple
User=$USER_NAME
ExecStart=/bin/bash -c 'bash $USER_HOME/startup_nexus_3.sh >> $USER_HOME/nexus3_out.log 2>> $USER_HOME/nexus3_err.log'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable startup_nexus3.service
    sudo systemctl start startup_nexus3.service
    echo "startup_nexus3.service has been created and started."
else
    echo "startup_nexus_3.sh not found - Skipping startup_nexus3.service creation."
fi
################################# END ###################################


echo "Script execution completed."