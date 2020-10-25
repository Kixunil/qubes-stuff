#!/bin/bash

# This script makes sure the webcam is attached to the correct VM, launches
# a QR-code scanner bundled in `qpay`. In the future, this could be improved# to work with other schemes as well.
#
# This script needs to be executedd in dom0

# The description of the webcam (see qvm-usb list)
DEV_DESCRIPTION=''
# The name of target VM which will be responsible for scanning
VM=''

function scan_devs() {
	USB_DEV="`qvm-usb list | grep "$DEV_DESCRIPTION"`"
	DEV_ID="`echo $USB_DEV | cut -d ' ' -f 1`"
	ATTACHED="`echo $USB_DEV | awk '{ print $3 }'`"
}

# Get the device ID or wait for connection
scan_devs
while [ -z "$DEV_ID" ];
do
	zenity --question --title='QR code reader' --text='The camera is not connecteed.' --ok-label='Retry' --cancel-label='Cancel' || exit 1
	scan_devs
done

case "$ATTACHED" in
	# Not attached
	"")
		qvm-usb attach "$VM" "$DEV_ID" || exit 1
		DETACH=1
		REATTACH=0
		;;
	# Already attached to the correct VM
	"$VM")
		DETACH=0
		REATTACH=0
		;;
	# Attached to a different VM
	*)
		# We don't want to mess with the setup without user approval
		zenity --question --title='QR code reader' --text='The camera is attached to a different VM.' --ok-label='Reattach' --cancel-label='Cancel' || exit 1
		qvm-usb detach "$ATTACHED" "$DEV_ID" || exit 1
		if qvm-usb attach "$VM" "$DEV_ID";
		then
			DETACH=1
			REATTACH=1
		else
			# Try to reattach to the previous VM in case of failure
			qvm-usb attach "$ATTACHED" "$DEV_ID"
			exit 1
		fi
		;;
esac

# Run qpay
qvm-run -p $VM 'qpay -q'

# Clean up if needed
if [ $DETACH -eq 1 ];
then
	qvm-usb detach "$VM" "$DEV_ID" || exit 1
fi

if [ $REATTACH -eq 1 ];
then
	qvm-usb attach "$ATTACHED" "$DEV_ID" || exit 1
fi<Paste>
