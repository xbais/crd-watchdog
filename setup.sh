#!/bin/bash

# Copying files
sudo cp crd-watchdog.sh /usr/local/bin/crd-watchdog.sh
sudo chmod +x /usr/local/bin/crd-watchdog.sh
sudo cp crd-watchdog.service /etc/systemd/system/crd-watchdog.service

# Enabling and starting service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable crd-watchdog
sudo systemctl start crd-watchdog
