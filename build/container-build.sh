#!/bin/sh

# setup user + abuild

apk add --no-cache sudo git alpine-sdk

adduser -D builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

addgroup builder abuild
mkdir -p /var/cache/distfiles
chmod a+w /var/cache/distfiles

home=/home/builder

sudo -i -u builder /bin/sh - << eof

mkdir -p $home/.ssh
cp -r /build-secrets/ssh-keys/* $home/.ssh/
chmod 700 $home/.ssh

mkdir -p $home/.abuild
cp /build-secrets/abuild/* $home/.abuild

eof

#######

/bin/sh


# su - builder
# mkdir -p ~/packages