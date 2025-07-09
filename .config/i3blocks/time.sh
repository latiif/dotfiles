#!/bin/bash
# filepath: /home/latiif/dotfiles/.config/i3blocks/time.sh

if [ "$BLOCK_BUTTON" = "1" ]; then
    yad --calendar --no-buttons --week-num --width=250 --height=220 &
    sleep 0.2
    i3-msg '[class="Yad"] floating enable, move position center' >/dev/null
fi

# Output bold date using Pango markup
echo "<b>$(date '+%-d   %H · %M')</b> "
