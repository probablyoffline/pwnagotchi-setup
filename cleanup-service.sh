#!/bin/bash

# Define variables
SCRIPT_PATH="/usr/local/bin/pwnagotchi-cleanup.sh"
SERVICE_PATH="/etc/systemd/system/pwnagotchi-cleanup.service"
SERVICE_NAME="pwnagotchi-cleanup"

# Create cleanup script
echo "[+] Creating cleanup script"
sudo tee $SCRIPT_PATH > /dev/null << EOF
#!/bin/bash
if [ \$(du -s /var/tmp/pwnagotchi | awk '{print \$1}') -gt 1000 ]; then
    rm -rf /var/tmp/pwnagotchi/*
fi
EOF
sudo chmod +x $SCRIPT_PATH

# Create systemd service file 
echo "[+] Creating service"
sudo tee $SERVICE_PATH > /dev/null << EOF
[Unit]
Description=Pwnagotchi Cleanup Service
After=network.target

[Service]
Type=Simple
ExecStart=$SCRIPT_PATH
Restart=always
RestartSec=300

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemon and start service
echo "[+] Reloading daemon"
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME
echo "[+] Pwnagotchi cleanup service started"
