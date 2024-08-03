#!/bin/bash

# =============================================
# Power Menu Script for Rofi
# =============================================

options_order=("󰍁 Lock" "󰗽 Logout" "󰤄 Suspend" " Reboot" "󰐥 Shutdown")
declare -A options=(
    ["󰍁 Lock"]="i3lock"
    ["󰗽 Logout"]="i3-msg exit"
    ["󰤄 Suspend"]="systemctl suspend"
    [" Reboot"]="systemctl reboot"
    ["󰐥 Shutdown"]="systemctl poweroff"
)

CONFIRM_SYMBOL="󰄬 Yes"
DECLINE_SYMBOL="󰅖 No"

confirm_cmd() {
    local choice
    choice=$(echo -e "$CONFIRM_SYMBOL\n$DECLINE_SYMBOL" | rofi \
        -dmenu \
        -theme-str 'entry { enabled: false; }' \
        -theme-str 'element-icon { enabled: false; }' \
        -p "Confirm your choice: $1")
    echo "$choice"
}

execute_option() {
    local option=$1
    local command=$2

    if [[ $(confirm_cmd "$option") == "$CONFIRM_SYMBOL" ]]; then
        $command
        return 0
    fi
    return 1
}

while true; do
    menu=$(printf "%s\n" "${options_order[@]}" | rofi -dmenu -i \
        -p "Power Menu" \
        -no-custom \
        -theme-str 'entry { enabled: false; }' \
        -theme-str 'element-icon { enabled: false; }')

    if [ -z "$menu" ]; then
        break
    fi

    execute_option "$menu" "${options[$menu]}" && break
done
