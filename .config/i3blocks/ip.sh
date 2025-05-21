#!/bin/bash

case $BLOCK_BUTTON in
    1) notify-send "IP" "Local IP: $(hostname -I | awk '{print $1}')\nExternal IP: $(curl -s ifconfig.me)" ;;
esac

echo "󰩟"

