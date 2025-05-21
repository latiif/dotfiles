#!/usr/bin/bash

echo -e "Cancel\nShutdown\nReboot\nLog out" | rofi -dmenu -i -p "Choose action:" | {
  read choice
  if [ "$choice" = "Shutdown" ]; then
    systemctl poweroff
  elif [ "$choice" = "Reboot" ]; then
    systemctl reboot
  elif [ "$choice" = "Log out" ]; then
    i3-msg exit
  fi
  # If Cancel or empty input, do nothing
}

