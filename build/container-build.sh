#!/bin/sh

# setup user + abuild

apk add --no-cache sudo git alpine-sdk

adduser -D builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

addgroup builder abuild
mkdir -p /var/cache/distfiles
chmod a+w /var/cache/distfiles

#######