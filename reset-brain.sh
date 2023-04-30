#!/bin/bash

echo "[=] Stopping pwnagtochi service"
sudo systemctl stop pwnagotchi.service
echo "[+] Erasing past life"
sudo rm -rf /root/handshakes/ /root/peers/ /var/log/pwnagotchi.log /root/brain.nn /root/brain.json
echo "[=] Starting pwnagtochi service"
sudo systemctl start pwnagotchi.service
echo "[+] Pwnagotchi reset complete"
