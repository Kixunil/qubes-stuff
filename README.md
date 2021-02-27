# My Qubes OS setup, tips and tricks

This repository contains various improvements on top of the default Qubes OS setup that I use.
I hope you can find some inspiration here and improve your Qubes experience.


## VM tips

* Clone the template image of a VM before modifying to make extra sure you have a clean image for your dispVMs or more critical setups.
* Use granular setup, especially divide work and fun.
  That way you can avoid temptation to do "fun stuff" when you work or vice versa.
  More information on this is written in [my lenghty article about Qubes and prodictivity](https://github.com/Kixunil/security_writings/blob/master/solving_security_and_procrastination.md).

## Interface

* I've added another auto-hiding panel with a bunch of quick shortcuts on the left side of the screen.
* Two important shortcuts are for showing QR code of selected text and switching keyboard (to Slovak and back) - see the [`scripts`](scripts/) directory.
* I use many (12) desktops with shortucts to switch between them.
  I don't have strict rules about mixing domains on a single desktop as some tasks require use of multiple domains.

## Automation

Most things can be seen in the scripts directory.
Some cool stuff:

* Sending a signal to `autossh` when the network changes - see [`signal_autossh.md`](signal_autossh.md)
* Attaching the camera to the correct VM and launching QR code scanner
* Creating QR codes from the selected text

## Tunnelling

Several applications I use need a tunnel to a remote machine.
This remote machine is controlled using SSH from a dedicated VM (`ssh-client`).
I start `autossh` using `/rw/config/rc.local` with the port forwarding options.
(See also how to send it a signal when the network changes.)
I use `socat` as a Qubes RPC service to provide these ports to other VMs.
Dom0 controls the access to these ports.
`socat` in individual VMs bridges the applications with Qubes RPC.

Credit for the idea goes to [Bitcoin Trezor Wiki](https://wiki.trezor.io/Qubes_OS)

## LNP/BP

I use tunneling described above for these LNP/BP applications:

* Electrum (connects to [`electrs`](https://github.com/romanz/electrs) running on my dedicated full node)
* Wasabi (connects to dedicated `bitcoind`)

I developed and use [`qpay`](https://github.com/Kixunil/qpay) for making Lightning payments securely and conveniently.
(It's even more convenient than non-Qubes setups!)
The `qpay` service runs in `ssh-client` which connects to a dedicated LN node.

I have forwarded important ports (22, 80, 443) of my node so that I don't have to mess around with Tor.

## Passwords and security

The isolation of Qubes allows me to remember passwords in the browser without having to worry much about it.
The idea is that if a VM gets compromised, then without password stored,
the malware could just interact with the browser directly to make actions on my behalf.
All the passwords are backed up in a dedicated VM with `seahorse` as the password manager.
The password manager VM is backed up regularly.
`seahorse` doesn't have an option to generate a password, but doing so is as simple as writing `head -c 18 /dev/urandom | base64`, so I don't worry about it too much.
Despite all this, I'd love to see FIDO Qubes implementation (separate VM acting as FIDO device).

Since I avoid using my passwords on machines that aren't owned by me, I don't bother with 2FA.
Having my laptop with Qubes *is* the second factor.

## Productivity and optimizations

* Using `mpsyt` avoids eating lot of memory by browser-based music players.
* The total time of using each VM can be logged and analyzed.
  [I wrote a tool to do that](https://github.com/Kixunil/ttt).
* Using DVMs for tests of my Debian packages makes it easy to solve corrupted system - just kill the VM and start a new one.

## Extra ideas that I don't use yet but may in the future

* [How to install potentially malicious binaries efficiently](installing_dangerous_binaries.md)
