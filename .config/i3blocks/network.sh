#!/bin/bash
#  = Wired (nf-mdi-ethernet)
#  = Wireless (nf-fa-wifi)
iface=$(ip route | awk '/default/ {print $5}')
state=$(cat /sys/class/net/$iface/operstate 2>/dev/null)

if [[ $iface == *"wl"* ]]; then
    icon=""
else
    icon=""
fi

echo "$icon $iface ($state)"

