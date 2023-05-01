#!/bin/bash

# Create route script
echo "[+] Creating route script"
sudo tee /home/pi/route.sh > /dev/null <<EOT
sudo ip route del default
sudo ip route del 192.168.1.0/24
sudo ip route add 192.168.1.0/24 via 192.168.1.1 dev eth0
sudo ip route add 192.168.0.1 dev eth0
sudo ip route add default via 192.168.0.1 dev eth0
EOT

# Make script executable
sudo chmod +x /home/pi/route.sh

# Create a systemd service unit file
echo "[+] Creating service"
sudo tee /etc/systemd/system/default-routes.service > /dev/null <<EOT
[Unit]
Description=Add default route

[Service]
Type=simple
ExecStart=/home/pi/route.sh

[Install]
WantedBy=multi-user.target
EOT

# Reload deamon and start service
echo "[=] Reloading daemon"
sudo systemctl daemon-reload
echo "[=] Enabling service"
sudo systemctl enable default-routes.service
echo "[=] Starting service"
sudo systemctl start default-routes.service

# Show new routes
echo "[+] Route addition complete"
sudo ip route
