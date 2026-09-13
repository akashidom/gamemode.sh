#!/usr/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 {start|end}"
  exit 1
fi

cache="$HOME/.cache/gamemode/"
statefile="$cache/tlp.state"
state="performance"

tlp="tlp.service"
ppd="tlp-pd.service"
throttled="throttled.service"

case "$1" in
  start)
    echo "Starting gamemode..."
    mkdir -pv "$cache"
    if [ ! -f "$statefile" ]; then
      tlpctl get | tee "$statefile"
    fi
    tlpctl set "$state"
    systemctl stop "$tlp" "$ppd"
    systemctl start "$throttled"
    ;;
  end)
    echo "Ending gamemode..."
    systemctl stop "$throttled"
    systemctl reset-failed "$tlp" "$ppd"
    systemctl start "$tlp" "$ppd"
    if [ -f "$statefile" ]; then
      tlpctl set "$(cat "$statefile")"
      rm "$statefile"
    fi
    ;;
  *)
    echo "Invalid argument: $1"
    echo "Usage: $0 {start|end}"
    exit 1
    ;;
esac