#!/bin/sh

host_uid=$1
host_gid=$2

# setup abuild

apk add --no-cache sudo git alpine-sdk nodejs

mkdir -p /var/cache/distfiles
chmod a+w /var/cache/distfiles

mkdir -p ~/.ssh
cp -r /mnt/build-secrets/ssh-keys/* ~/.ssh/
chmod 700 ~/.ssh

mkdir -p ~/.abuild
cp /mnt/build-secrets/abuild/* ~/.abuild

mkdir -p ~/packages
ln -s /mnt/build ~/packages/build
mkdir ~/build # this folder will serve as output subdirectory

# build packages

/mnt/scripts/build-package.sh mylife-home-core
/mnt/scripts/build-package.sh mylife-home-core-plugins-irc

# cleanup

chown -R $host_uid:$host_gid /mnt/build/*

# debug
# /bin/sh
