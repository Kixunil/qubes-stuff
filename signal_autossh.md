# How to send signal to autossh when network changes

Problem: `autossh` can reconnect when the connection drops but it can take a long time for it to find out the connection dropped when you reconnect.
(Put laptop to sleep, wake it up elswhere and connect to a different WiFi network.)
Solution: send `SIGUSR1` signal to it whenever the network changes.

This is not a single script but a bunch of few-liners, so I guess it will be better to write it as a tutorial in a single document.

## sys-net

You need to have this script stored in `sys-net`, in `/usr/local/bin/network_notify_vm`:

```bash
#!/bin/bash

# Name of VM to be notified of network change
TARGET_VM=""

if [ "$2" = "up" ];
then
	qrexec-client-vm $TARGET_VM network-change-notify
fi

```

Then you need to copy it to the proper directory on each boot.
Put this in `/rw/config/rc.local`:

```bash
cp /usr/local/bin/network_notify_vm /etc/NetworkManager/dispatcher.d/network_notify_vm
chmod 700 /etc/NetworkManager/dispatcher.d/network_notify_vm
```

## Target VM

Put this script into `/usr/local/etc/qubes-rpc/network-change-notify` of the VM that needs to be notified of network change:

```bash
#!/bin/bash

killall -SIGUSR1 autossh
```

## Dom0 configuration

Put this into `/etc/qubes-rpc/policy/network-change-notify`

```
sys-net  TARGET_VM_HERE  allow
@anyvm   @anyvm      deny
```

Don't forget to replace `TARGET_VM_HERE` with your actual VM name. ;)

## Conclusion

That's all!
With this setup the experience of using `autossh` and `rscreen` is much, much smoother.
I almost never notice any lag on reconnecting - it just continues to work.
