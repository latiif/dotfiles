#!/bin/bash

# Get the LED mask from xset
led_mask=$(xset -q | grep LED | awk '{ print $10 }')

# Match exact values for layouts
case "$led_mask" in
  00000002)
    echo "EN"
    ;;
  00001002)
    echo "AR"
    ;;
  *)
    echo "🌐 ??"
    ;;
esac

