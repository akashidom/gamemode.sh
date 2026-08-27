#!/usr/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 {start|end}"
  exit 1
fi

cache="$HOME/.cache/gamemode/"
state="$cache/power-profiles-daemon.state"
ppd="performance"

case "$1" in
  start)
    echo "Starting gamemode..."
    mkdir -pv "$cache"
    if [ ! -f "$state" ]; then
      powerprofilesctl get | tee "$state"
    fi
    powerprofilesctl set "$ppd"
    systemctl stop ananicy-cpp.service
    ;;
  end)
    echo "Ending gamemode..."
    if [ -f "$state" ]; then
      powerprofilesctl set "$(cat "$state")"
      rm "$state"
    fi
    systemctl start ananicy-cpp.service
    ;;
  *)
    echo "Invalid argument: $1"
    echo "Usage: $0 {start|end}"
    exit 1
    ;;
esac