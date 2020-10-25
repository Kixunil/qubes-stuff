#!/bin/bash

# This script runs a command in the appVM that has currently focus
# It's a fundamental building block of other commands.
#
# It must be installed in /usr/local/bin/fqrun of dom0

FRONT_VM=$(xprop -notype -id $(xprop -root -notype _NET_ACTIVE_WINDOW | sed -e 's/^.*# //' -e 's/,.*$//') _QUBES_VMNAME | cut -d '"' -f 2) && qvm-run "$FRONT_VM" "$1"
