#!/bin/bash

# Completely vibe coded btw
# Define the main menu options
options="Lock\nSuspend\nLogout\nReboot\nShutdown"

# Get the chosen action
chosen=$(printf "$options" | fuzzel --dmenu --prompt "Power: " --lines 5)

# Exit immediately if the user presses Escape or closes the menu
if [ -z "$chosen" ]; then
    exit 0
fi

# Function to trigger the confirmation menu
confirm_action() {
    # Putting "No" first makes it the default selected option
    local confirmation="No\nYes"
    local result=$(printf "$confirmation" | fuzzel --dmenu --prompt "Are you sure? " --lines 2)

    if [ "$result" = "Yes" ]; then
        return 0 # User confirmed
    else
        return 1 # User aborted
    fi
}

# Execute the corresponding command based on the selection
case "$chosen" in
    Lock) 
        jay run-privileged swaylock -c 1f1f1f
        ;;
    Suspend) 
        systemctl suspend 
        ;;
    Logout) 
        # Only runs the loginctl command if confirm_action returns 0 (Yes)
        confirm_action && loginctl terminate-user $USER 
        ;;
    Reboot) 
        confirm_action && systemctl reboot 
        ;;
    Shutdown) 
        confirm_action && systemctl poweroff 
        ;;
esac