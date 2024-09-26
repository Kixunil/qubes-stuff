# Tunnel setup

The general idea is to separate the SSH keys from clients using the tunnel. This allows sharing a single TCP connection over the physical network while retaining security. This has also an interesting property that you can disable network in the client VM so that no data is accidentaly leaked.

See also [how to send it a signal](signal_autossh.md).

## Example: electrs

* In an ssh VM run `autossh -L 50001:localhost:50001 $user@$host` (replace `$user` and `$host` with your values)
* Configure electrum service by creating an executable file `/usr/local/etc/qubes-rpc/electrum-service` containing `socat - TCP:localhost:50001`
* Configure qubes policy to allow `electrum-service` in SSH VM to be accessed by the client VM
* In a client VM (where an electrum client is used) run: `socat TCP-LISTEN:50001,fork EXEC:qrexec-client-vm $ssh_vm electrum-service` (replace `$ssh_vm` with your VM name)
* Configure the Electrum client to connect to `localhost:50001:t`
* Optionally disable the network in the Electrum client VM

Now the connection from the client will be tunneled by the SSH qube to your dedicated full node.

You can do the same with pretty much any service you want - just rename the service and use different ports.
You can use several `-L $port:localhost:$port` statements to tunnel everything in a single connection.
Once you have tested it add it to rc.local or create a systemd service.

This was inspired by an old version of https://wiki.trezor.io/Qubes\_OS - see Internet Archive.
