#!/bin/bash

# Runs setxkbmap in the focused VM
# Run from dom0 with fqrun installed.

fqrun 'DISPLAY=:0.0 setxkbmap '"$*"
