#!/usr/bin/env bash

# Chrome Remote Desktop service base name
CRD_BASE="chrome-remote-desktop"

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

# Function: get all CRD service units (main + @instances)
get_crd_units() {
    systemctl list-unit-files \
        | awk '{print $1}' \
        | grep -E "^${CRD_BASE}(@.*)?\.service$"
}

# Function: stop all CRD units
stop_crd() {
    units=$(get_crd_units)
    [[ -n "$units" ]] && systemctl stop $units
}

# Function: start all CRD units
start_crd() {
    units=$(get_crd_units)
    [[ -n "$units" ]] && systemctl start $units
}

# Function: check if any CRD unit is active
any_crd_active() {
    systemctl is-active --quiet "${CRD_BASE}.service" && return 0
    systemctl list-units --type=service --state=active \
        | grep -qE "^${CRD_BASE}@.*\.service"
}

while true; do
    if display_connected; then
        # Display connected → stop all CRD instances
        if any_crd_active; then
            stop_crd
        fi
    else
        # No display → start all CRD instances
        if ! any_crd_active; then
            start_crd
        fi
    fi

    sleep "$INTERVAL"
done
