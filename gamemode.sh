#!/usr/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 {start|end}"
  exit 1
fi

cache="$HOME/.cache/gamemode/"
statefile="$cache/power-profiles-daemon.state"
state="performance"

ppd="power-profiles-daemon.service"
throttled="throttled.service"

case "$1" in
  start)
    echo "Starting gamemode..."
    mkdir -pv "$cache"
    if [ ! -f "$statefile" ]; then
      powerprofilesctl get | tee "$statefile"
    fi
    powerprofilesctl set "$state"
    systemctl stop "$ppd"
    systemctl reset-failed "$throttled"
    ;;
  end)
    echo "Ending gamemode..."
    systemctl stop "$throttled"
    systemctl reset-failed "$ppd"
    systemctl start "$ppd"
    if [ -f "$statefile" ]; then
      powerprofilesctl set "$(cat "$statefile")"
      rm "$statefile"
    fi
    ;;
  *)
    echo "Invalid argument: $1"
    echo "Usage: $0 {start|end}"
    exit 1
    ;;
esac