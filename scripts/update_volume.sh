#!/bin/bash

# This script periodically synchronizes the volume of dom0 with the volume
# of the running sink in an appVM. This is only useful if the VM in question
# uses a different output device than dom0 - e.g. BT headphones.

TARGET_VM=""

while :;
do
	qvm-run "$TARGET_VM" "set_volume `amixer get Master | grep 'Mono: Playback' | sed  's/^.*\[off\].*$/0%/' | sed 's/^[^\[]*\[//g' | sed 's/\].*$//g'`"
	sleep 1
done

