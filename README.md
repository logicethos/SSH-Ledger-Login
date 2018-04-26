# SSH Ledger Login

Protect your servers, using Ledger Nano S.
Stop system admins from using weak passwords!

### Setup Server

Copy server-setup.sh
Read the comments in server-setup.sh
As root:
```bash server-setup.sh```

### Add users
```useradd -m -s /bin/bash -G sudo,keyset <user>```

### Update existing users
```usermod -a -G sudo,keyset stuart```

### To login from a Linux Client
TODO

### Create a server list
TODO

### To connect to your servers
Install the SSH/PGP Agent application


### To setup your Ledger Nano S
Install the SSH/PGP Agent application on your Ledger Nano S
[See first part of this guide](https://thoughts.t37.net/a-step-by-step-guide-to-securing-your-ssh-keys-with-the-ledger-nano-s-92e58c64a005)