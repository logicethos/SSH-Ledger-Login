# Ledger SSH System Admin

##### Protect your servers, using Ledger Nano S.
##### Stop users from using weak passwords!
----

Users added to the group 'keyset', will be required to upload a public key from the Ledger when they connect.
After they have done this, they will be automatically removed from 'keyset', and added to 'keyonly' group. No more passwords.
Users added to the sysadmin group, will get password-less sudo (i.e full root access).

#### Setup Server

Copy & execute server_setup.sh
As root:
``` wget https://raw.githubusercontent.com/logicethos/SSH-Ledger-Login/master/server-setup.sh```
```bash server_setup.sh```
Restart OpenSSH
```/etc/init.d/ssh restart```

### Add users (using optional sysadmin)
```useradd -m -s /bin/bash -G keyset,sysadmin <user>```
set up a tempory password.
```passwd <user>```
### Update existing users (using optional sysadmin)
```usermod -a -G keyset,sysadmin <user>```

----
### To setup your Ledger Nano S
Install the SSH/PGP Agent application
[See first part of this guide](https://thoughts.t37.net/a-step-by-step-guide-to-securing-your-ssh-keys-with-the-ledger-nano-s-92e58c64a005)

### To login from a Linux Client
TODO
docker run --rm -it --privileged -v /dev/bus/usb:/dev/bus/usb ledger-ssh
