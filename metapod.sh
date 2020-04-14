#!/bin/bash
if [ $(id -u) -eq 0 ]
then
  echo "
===================================================
===================================================
   _____          __                           .___
  /     \   _____/  |______  ______   ____   __| _/
 /  \ /  \_/ __ \   __\__  \ \____ \ /  _ \ / __ |
/    Y    \  ___/|  |  / __ \|  |_> >  <_> ) /_/ |
\____|__  /\___  >__| (____  /   __/ \____/\____ |
        \/     \/          \/|__|               \/
                               ...Kali but harder!
===================================================
==================================================="
  read -n 1 -s -r -p "Press any key to use the only attack you know :p"; echo

  echo "+Let's get that root password changed for a start..."
  passwd root

  echo "+Creating new user..."
  read -p "Enter username : " username
  egrep "^$username" /etc/passwd >/dev/null
  if [ $? -eq 0 ]
  then
    echo "!!! Username already exists! Try again !!!"
  else
    adduser $username --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
    echo "+Adding new user to sudoers..."
    usermod -aG sudo $username
    passwd $username
  fi

  echo "=== Metapod uses Harden! ==="
  echo "+Backing up old ssh keys..."
  cd /etc/ssh
  mkdir kali_default
  mv ssh_host_* kali_default/

  echo "+Regenerating ssh keys..."
  dpkg-reconfigure openssh-server

  echo "--- Verify these hashes ---"
  md5sum ssh_host_*
  echo "--- Are different to the defaults ---"
  cd kali_default/
  md5sum *
  read -n 1 -s -r -p "Any key to continue..."; echo

  echo "+Updating and upgrading packages..."
  apt-get update && apt-get upgrade && apt-get dist-upgrade

  echo "=== Attack was super effective! All done! ==="
fi
