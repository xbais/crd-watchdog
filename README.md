# Chrome Remote Desktop - Watchdog
## Installation
1. Save the shell script as `/usr/local/bin/crd-watchdog.sh`
2. Make it executable: `sudo chmod +x /usr/local/bin/crd-watchdog.sh`
3. Copy the service file to this location: `/etc/systemd/system/crd-watchdog.service`

## Enable and run the watchdog
```
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable crd-watchdog
sudo systemctl start crd-watchdog
```
