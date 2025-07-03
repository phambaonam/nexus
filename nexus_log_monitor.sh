#!/bin/bash

# 1) Wait for GNOME Terminal to appear
while true; do
  WIN_ID=$(xdotool search --onlyvisible --class gnome-terminal | head -n1)
  if [[ -n "$WIN_ID" ]]; then
    break
  fi
  sleep 30
done

# 2) Wait for log files to exist
while true; do
  if [[ -f "$HOME/nexus_out_1.log" && -f "$HOME/nexus_err_1.log" ]]; then
    echo "Both log files found, proceeding..."
    break
  fi
  echo "Log files not found, waiting 5 minutes..."
  sleep 300  # Wait 5 minutes
done

# ——————————————————————————————————————————————————————————————
# Code below only runs after the loop ends
# example: open new tabs and tail files

# Activate the terminal window
xdotool windowactivate --sync "$WIN_ID"

# Open tab and tail FILE1
xdotool key --clearmodifiers ctrl+shift+t
sleep 0.2
xdotool type --delay 1 "tail -f \"$HOME/nexus_out_1.log\""
xdotool key Return

# Open tab and tail FILE2
xdotool key --clearmodifiers ctrl+shift+t
sleep 0.2
xdotool type --delay 1 "tail -f \"$HOME/nexus_err_1.log\""
xdotool key Return

exit 0