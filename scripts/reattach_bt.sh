#!/bin/bash

# I use Bluetooth in untrusted VM for playing music.
# It's a bit glitchy though and the solution is to detach and re-attach the device multiple times.
# This script helps with that.
#
# This script must be executed in dom0

# Enter ID of your device (see qvm-usb list)
DEVICE_ID=""
# Enter the name of the VM you want to attach the deice to
TARGET_VM=""

BT_DEV=`qvm-usb list | grep 04ca_300d | cut -d ' ' -f 1`

qvm-usb attach "$TARGET_VM" "$BT_DEV"
sleep 1
qvm-usb detach "$TARGET_VM" "$BT_DEV"
sleep 1
qvm-usb attach "$TARGET_VM" "$BT_DEV"

qvm-run "$TARGET_VM" blueman-applet &

