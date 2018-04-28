#!/bin/bash

# SSH-Ledger-Login Setup script
#
# Execute this script on a linux server (Works on Ubuntu) to allow users Ledger access using the docker client menu system.
#
# Users added to the group 'keyset', will be required to upload a public key from the Ledger
# After they have done this, they will be automatically removed from 'keyset', and added to 'keyonly' group.
# Users added to the sysadmin group, will get passwordless sudo (i.e full root access).
#
# To add new users (with optional sysadmin):
#   useradd -m -G keyset,sysadmin <User>
# Set a temporary password
#   passwd <user>
#
# Add existing users to keyset,& optional sysadmin
#   usermod -a -G sudo,keyset <user>
#
# Restart ssh
#   /etc/init.d/ssh restart
#
#

#Create a new group, that signals to sshd, that a password is allowable for a new user to upload public key
groupadd keyset

#Create a new group, that signals to sshd, this is a key holder
groupadd keyonly

#Create a new group, that allows passwordless sudo to system admins
groupadd sysadmin

#Configure sshd, to match the new group, allow password login, and execute a script.
cat >> /etc/ssh/sshd_config << EOL
#PasswordAuthentication no

Match Group keyonly
    PasswordAuthentication no

Match Group keyset
    PasswordAuthentication yes
    ForceCommand /usr/local/bin/keyset-remove
EOL


#Create the login script for sshd
cat > /usr/local/bin/keyset-remove << \EOL
#!/bin/sh

if echo $SSH_ORIGINAL_COMMAND | grep -q "LedgerKey"; then
   cd
   umask 077
   mkdir -p .ssh && cat >> .ssh/authorized_keys || exit 1
   if type restorecon >/dev/null 2>&1 ; then restorecon -F .ssh .ssh/authorized_keys ; fi
   sudo usermod -a -G keyonly $USER
   sudo deluser $USER keyset
   sudo usermod --shell /bin/bash $USER
   echo "Server says, Thank you."
else
   echo $($SSH_ORIGINAL_COMMAND)
   echo "Error: not what I was expecting!"
fi;
EOL

#Set execution flag
chmod +x /usr/local/bin/keyset-remove

#Remove password for sudoers

cat >> /etc/sudoers << EOL
%sysadmin ALL=(ALL) NOPASSWD: ALL
%keyset ALL = (root) NOPASSWD: /usr/sbin/deluser
%keyset ALL = (root) NOPASSWD: /usr/sbin/usermod

EOL