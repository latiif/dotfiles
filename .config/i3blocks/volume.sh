#!/bin/bash

# Get current volume and mute status using pamixer
VOLUME=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

# Detect if headphones are connected using pactl
HEADPHONES_CONNECTED=$(pactl list sinks | grep -i 'active port' | grep -q 'headphones' && echo "true" || echo "false")

# Choose appropriate emoji
if [ "$MUTED" = "true" ]; then
    ICON=""
elif [ "$HEADPHONES_CONNECTED" = "true" ]; then
    ICON="󰋋"
else
    ICON="󰕾"
fi

# Output volume info with icon
echo "$ICON  $VOLUME"

# Handle click events
case "$BLOCK_BUTTON" in
    1) pamixer -t ;;                    # Left click: toggle mute
    4) pamixer --increase 5 ;;          # Scroll up: volume up
    5) pamixer --decrease 5 ;;          # Scroll down: volume down
esac

