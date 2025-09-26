#!/bin/bash
# Checks if a VPN interface is up and prints a Waybar-compatible JSON object.


is_vpn_connected() {
    ip addr show $1 > /dev/null 2>&1
}

display() {
  if is_vpn_connected $1; then
      echo "{\"text\":\"\",\"tooltip\":\"$1 is connected\",\"class\":\"connected\"}"
  else
      echo "{\"text\":\" \",\"tooltip\":\"$1 is disconnected\",\"class\":\"disconnected\"}"
  fi
}

toggle() {
  if is_vpn_connected $1; then
      sudo wg-quick down $1
  else
      sudo wg-quick up $1
  fi
  pkill -RTMIN+8 waybar 2>/dev/null || true
}


# Main execution
case "$2" in
    "display")
        display $1
        ;;
    "toggle")
        toggle $1
        ;;
    *)
        # Default to display if no second argument provided
        display $1
        ;;
esac
