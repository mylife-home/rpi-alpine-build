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
cp -r /mnt/build-secrets/ssh-keys/* $home/.ssh/
chmod 700 $home/.ssh

mkdir -p $home/.abuild
cp /mnt/build-secrets/abuild/* $home/.abuild

eof

# build core

sudo -i -u builder /bin/sh - << eof

mkdir $home/build
mkdir $home/packages
cd $home/build
cp -r /mnt/build/packages/mylife-home-core/* .
mkdir dist
cp -r /mnt/dist/prod/core/* ./dist

eof

#####

/bin/sh


# su - builder
# mkdir -p ~/packages