#!/bin/bash

sudo tee /etc/systemd/system/startup_nexus.service > /dev/null << 'EOF'
[Unit]
Description=Auto Start Nexus node
After=network-online.target

[Service]
Type=simple
User=user
ExecStart=/bin/bash -c 'bash /home/user/startup_nexus_1.sh >> /home/user/nexus_out_1.log 2>> /home/user/nexus_err_1.log'
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

###########

sudo tee /etc/systemd/system/startup_nexus2.service > /dev/null << 'EOF'
[Unit]
Description=Auto Start Nexus2 node
After=network-online.target

[Service]
Type=simple
User=user
ExecStart=/bin/bash -c 'bash /home/user/startup_nexus_2.sh >> /home/user/nexus2_out.log 2>> /home/user/nexus2_err.log'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable startup_nexus2.service
sudo systemctl start startup_nexus2.service

###########

sudo tee /etc/systemd/system/startup_nexus3.service > /dev/null << 'EOF'
[Unit]
Description=Auto Start Nexus3 node
After=network-online.target

[Service]
Type=simple
User=user
ExecStart=/bin/bash -c 'bash /home/user/startup_nexus_3.sh >> /home/user/nexus3_out.log 2>> /home/user/nexus3_err.log'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable startup_nexus3.service
sudo systemctl start startup_nexus3.service