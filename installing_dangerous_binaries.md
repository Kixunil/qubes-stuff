# Installing dangerous binaries

## Disclaimer

I do not use this now, but I may in the future.
I'm very confident in this being OK.

## Problem statement

You have a closed-source binary and you want to launch multiple instances in different app VMs.
You don't want to poison other app VMs, not even by accident.
You don't want to waste space.
You don't want to waste time by managing updatess in each app VM.

## Solution

Assume the binary is statically linked, called `possibly_evil`.
You downloaded it in `disp123`.
You want to copy it to `debian-10` template VM.

**Warning: if your template VM is actually whonix-ws (or, God forbid, whonix-gw) your privacy will be destroyed!**

1. Go to `disp123` in directory in which you downloaded the binary
2. `qvm-copy possibly_evil`
3. Select `debian-10`
4. Go to `debian-10` terminal
5. `cd ~/QubesIncoming/disp123`
6. `chmod 644 possibly_evil` - do **not** continue if this command failed for any reason!!!
7. `sudo cp possibly_evil /usr/local.orig/bin`
8. `sudo shutdown -h now`
9. Create/run an appVM based on this template where you will use this binary
10. Edit /rw/config/rc.local
11. Add this line: `chmod 755 /usr/local.orig/bin/possibly_evil`
12. Add this line: `ln -s /usr/local.orig/bin/possibly_evil /usr/local/bin/`
13. Repeat steps 9-12 (including) for each additional appVM which will use this binary.

If you need to update, just repeat the steps 1-8 (including) and restart app vms

## Why is this safe

* We never execute this binary in template VM
* Clearing executable bit avoids accidental execution in trusted VMs
* We only re-set the executable bit in VMs which are supposed to execute this binary
