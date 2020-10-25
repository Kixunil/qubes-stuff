#!/bin/bash

# This script sets the volume of the running sink to the desired value (the
# argument)
# It can be used together with update_volume.sh
# This script should be placed in /usr/local/bin/set_volume of the target VM.

SINK_NUM=`pactl list | grep -B 1 'State: RUNNING' | head -1 | sed 's/^Sink #//'`

pactl set-sink-volume "$SINK_NUM" "$1"
