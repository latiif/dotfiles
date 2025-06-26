#!/bin/bash

# Get CPU usage
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')
cpu_usage=$(printf "%.0f" "$cpu_idle")

# Get Memory usage
mem_info=$(free -m | grep Mem)
mem_used=$(echo "$mem_info" | awk '{print $3}')
mem_total=$(echo "$mem_info" | awk '{print $2}')
mem_usage=$((100 * mem_used / mem_total))

# Color and emoji logic
colorize() {
  usage=$1
  emoji=$2
  if [ "$usage" -lt 50 ]; then
    echo "<span foreground='light green'>${emoji}$usage%</span>"
  elif [ "$usage" -lt 80 ]; then
    echo "<span foreground='light orange'>${emoji}$usage%</span>"
  else
    echo "<span foreground='light red'>${emoji}$usage%</span>"
  fi
}

cpu_text=$(colorize "$cpu_usage" "")
mem_text=$(colorize "$mem_usage" "")

echo -e "<b>$cpu_text $mem_text</b>"

