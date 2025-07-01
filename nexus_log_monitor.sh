#!/bin/bash

# 1) Wait for GNOME Terminal to appear
while true; do
  WIN_ID=$(xdotool search --onlyvisible --class gnome-terminal | head -n1)
  if [[ -n "$WIN_ID" ]]; then
    break
  fi
  sleep 30
done

# Wait for nexus cli installed and run node
sleep 300

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