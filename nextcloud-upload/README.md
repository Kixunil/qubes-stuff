# Nextcloud upload

## Upload a file from any VM to your Nextcloud server without giving away password

This tool works is similar to `qvm-copy` or `qpay`.
It uploads a file from any VM to your Nextcloud server
while avoiding disclosing password to possibly untrusted VM.

It also restricts permission to only upload the file to specific directory, exactly as qvm-copy does.
However, uploading directories is not yet supported.

## Setup

1. `sudo cp nextcloud-upload /usr/local/etc/qubes-rpc` in nextcloud-vm - this will have the password
2. Create `~/.netrc` and fill credentials - see example below
3. Create `~/.config/nextcloud-upload` and fill config - see below
4. `sudo cp nc-upload /usr/local/bin` in other AppVM.

`~/.netrc`:

```
machine example.com
login satoshi
password craigwrightisafraud
```

`~/.config/nextcloud-upload`:

```
nc_server="https://example.com/nextcloud"
user_name="satoshi"
```

## Usage

```bash
nc-upload /path/to/file
```

This will create `QubesIncoming/$VM/` directory **on the server** if it doesn't exist and places `file` inside.
