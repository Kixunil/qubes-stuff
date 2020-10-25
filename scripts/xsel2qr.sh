#!/bin/bash

# This script creates a QR code out of the cursor-selected text in the focused VM and displays it.
# All appvms that want to use this must have xsel and qrencode installed
# This scripts needs to be executed in dom0, which has fqrun installed.

fqrun 'xsel | qrencode -o /tmp/qr-out.png && DISPLAY=:0.0 xdg-open /tmp/qr-out.png'
