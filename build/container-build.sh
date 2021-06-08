#!/bin/sh

# setup abuild

apk add --no-cache sudo git alpine-sdk nodejs

mkdir -p /var/cache/distfiles
chmod a+w /var/cache/distfiles

mkdir -p ~/.ssh
cp -r /mnt/build-secrets/ssh-keys/* ~/.ssh/
chmod 700 ~/.ssh

mkdir -p ~/.abuild
cp /mnt/build-secrets/abuild/* ~/.abuild

# build core

mkdir ~/build
mkdir ~/packages
cd ~/build
cp -r /mnt/build/packages/mylife-home-core/* .
cp -r /mnt/dist/prod/core/bin.js ./
cp -r /mnt/dist/prod/core/bin.js.map ./
cp -r /mnt/dist/prod/core/lib.js ./
cp -r /mnt/dist/prod/core/lib.js.map ./

abuild -F checksum
abuild -F -r

#####


/bin/sh


# su - builder
# mkdir -p ~/packages