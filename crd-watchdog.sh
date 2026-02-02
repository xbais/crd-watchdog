#!/usr/bin/env bash

# Chrome Remote Desktop service name
CRD_SERVICE="chrome-remote-desktop.service"

# Check interval (seconds)
INTERVAL=120

# Function: detect if any physical display is connected
display_connected() {
    for status in /sys/class/drm/*/status; do
        [[ -f "$status" ]] || continue
        if grep -q "connected" "$status"; then
            return 0
        fi
    done
    return 1
}

# Function: is CRD running?
crd_active() {
    systemctl is-active --quiet "$CRD_SERVICE"
}

while true; do
    if display_connected; then
        # Display is connected → stop CRD if running
        if crd_active; then
            systemctl stop "$CRD_SERVICE"
        fi
    else
        # No display → start CRD if not running
        if ! crd_active; then
            systemctl start "$CRD_SERVICE"
        fi
    fi

    sleep "$INTERVAL"
done
