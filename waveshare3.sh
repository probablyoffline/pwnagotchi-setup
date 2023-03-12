#!/bin/bash

# Define the file paths
file_path1="/usr/local/lib/python3.7/dist-packages/pwnagotchi/ui/hw/__init__.py"
file_path2="/usr/local/lib/python3.7/dist-packages/pwnagotchi/ui/display.py"
file_path3="/usr/local/lib/python3.7/dist-packages/pwnagotchi/utils.py"
file_path4="/etc/pwnagotchi/config.toml"

# Make backups
echo "[+] Making backups"
cp ${file_path1} ${file_path1}.bak
cp ${file_path2} ${file_path2}.bak
cp ${file_path3} ${file_path3}.bak
cp ${file_path4} ${file_path4}.bak

# Define the target and replacement strings
target_str='ui.display.type = "waveshare_2"'
replacement_str='ui.display.type = "waveshare_3"'
target_line="from pwnagotchi.ui.hw.waveshare2 import WaveshareV2"
new_line="from pwnagotchi.ui.hw.waveshare3 import WaveshareV3"

# Define the content to append
content1='\\n'"    elif config['ui']['display']['type'] == 'waveshare_3':\n        return WaveshareV3(config)"
content2="/def is_waveshare27inch/i\    def is_waveshare_v3(self):\n        return self._implementation.name == 'waveshare_3'\n"
content3='\\n'"    elif config['ui']['display']['type'] in ('ws_3', 'ws3', 'waveshare_3', 'waveshare3'):\n        config['ui']['display']['type'] = 'waveshare_3'"

# Search for the line that needs to be edited
line_number1=$(grep -n "return WaveshareV2(config)" $file_path1 | cut -d: -f1)
line_number3=$(grep -n "= 'waveshare_2'" $file_path3 | cut -d: -f1)

# Append the new content after the target line
echo "[+] Updating __init__.py"
sed -i "${line_number1}a ${content1}" $file_path1
# Check if the target line exists in the file
if grep -qF "$target_line" "$file_path1"; then
    # The target line exists, so add the new line after it
    sed -i "/$target_line/a $new_line" "$file_path1"
    echo "[+] Added $new_line"
else
    # The target line does not exist, so print an error message
    echo "[x] Error: $target_line not found"
fi
echo "[+] Updating display.py"
sed -i "${content2}" $file_path2
echo "[+] Updating utils.py"
sed -i "${line_number3}a ${content3}" $file_path3


# Check if the target string exists in the file
echo "[+] Updating config.toml"
if grep -qF "$target_str" "$file_path4"; then
        sed -i "s/$target_str/$replacement_str/" "$file_path4"
        echo "[+] Updated ui.display.type value to waveshare_3"
elif grep -qF "$replacement_str" "$file_path4"; then
        # The replacement string already exists, so do nothing
        echo "[=] ui.display.type value is already waveshare_3"
else
    # The target string does not exist, so print an error message
    echo "[x] Error: ui.display.type value is not set to waveshare_2"
fi

# Create necessary directories
sudo mkdir -p /usr/local/lib/python3.7/dist-packages/pwnagotchi/ui/hw/libs/waveshare/v3

# Download files
echo "[+] Downloading waveshare 3 files"
sudo curl -o /usr/local/lib/python3.7/dist-packages/pwnagotchi/ui/hw/libs/waveshare/v3/epd2in13_V3.py https://raw.githubusercontent.com/ikornaselur/pwnagotchi/e878e05485a3403ac23f35af1ac3d57648773c31/pwnagotchi/ui/hw/libs/waveshare/v3/epd2in13_V3.py
sudo curl -o /usr/local/lib/python3.7/dist-packages/pwnagotchi/ui/hw/libs/waveshare/v3/epdconfig.py https://raw.githubusercontent.com/ikornaselur/pwnagotchi/e878e05485a3403ac23f35af1ac3d57648773c31/pwnagotchi/ui/hw/libs/waveshare/v3/epdconfig.py
sudo curl -o /usr/local/lib/python3.7/dist-packages/pwnagotchi/ui/hw/waveshare3.py https://raw.githubusercontent.com/ikornaselur/pwnagotchi/e878e05485a3403ac23f35af1ac3d57648773c31/pwnagotchi/ui/hw/waveshare3.py
sudo systemctl restart pwnagotchi.service
echo "[+] waveshare 3 configured"
