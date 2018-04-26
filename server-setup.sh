#!/bin/bash

# SSH-Ledger-Login Setup script
#
# Execute this script on a linux server (Works on Ubuntu) to allow System Admins access.
# If you want to remove all possibility of password logins, then uncomment 'PasswordAuthentication no' below
# Be careful not to lock yourself out if your server!
#
# Users added to the group 'keyset', will be required to upload a public key from the Ledger
# After they have done this, they will be automatically removed from 'keyset', and added to 'keyonly'.
#
# To add new users:
#   useradd -m -s /bin/bash -G sudo,keyset <User>
# Set a temporary password
#   passwd <user>
#
# Add existing users to the sudo,keyset
#   usermod -a -G sudo,keyset <User>
#
# Restart ssh
#   /etc/init.d/ssh restart
#
#

#Create a new group, that signals to sshd, that a password is allowable for a new user to upload public key
groupadd keyset

#Create a new group, that signals to sshd, this is a key holder
groupadd keyonly

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
cat > /usr/local/bin/keyset-remove << EOL
#!/bin/sh

if echo $SSH_ORIGINAL_COMMAND | grep -1 "authorized_keys"; then
   $($SSH_ORIGINAL_COMMAND) 
   sudo deluser $USER keyset
   sudo usermod -a -G keyonly $USER
else
   echo "Where is your Ledger?"
fi;
EOL

#Set execution flag
chmod +x /usr/local/bin/keyset-remove

#Remove password for sudoers

cat >> /etc/sudoers << EOL
%sudo ALL=(ALL) NOPASSWD: ALL
%keyset ALL = (root) NOPASSWD: /usr/bin/deluser

EOL