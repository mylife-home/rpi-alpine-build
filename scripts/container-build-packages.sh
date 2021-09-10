#!/bin/sh

host_uid=$1
host_gid=$2

function main() {
  setup_abuild

  build_package mylife-home-core
  build_package mylife-home-core-plugins-irc
  build_package mylife-home-core-plugins-logic-base
  build_package mylife-home-core-plugins-logic-colors
  build_package mylife-home-core-plugins-logic-selectors
  build_package mylife-home-core-plugins-logic-timers
  build_package mylife-home-core-plugins-ui-base

  finalize

  # debug
  # /bin/sh
}

function setup_abuild() {
  apk add --no-cache sudo git alpine-sdk nodejs

  mkdir -p /var/cache/distfiles
  chmod a+w /var/cache/distfiles

  mkdir -p ~/.ssh
  cp -r /mnt/build-secrets/ssh-keys/* ~/.ssh/
  chmod 700 ~/.ssh

  mkdir -p ~/.abuild
  cp /mnt/build-secrets/abuild/* ~/.abuild
  cp ~/.abuild/*.rsa.pub /etc/apk/keys

  mkdir -p ~/packages
  ln -s /mnt/build ~/packages/build
  mkdir ~/build # this folder will serve as output subdirectory
}

function finalize() {
  chown -R $host_uid:$host_gid /mnt/build/*
}

function build_package() {
  local package=$1

  mkdir ~/build/$package
  cd ~/build/$package
  cp -r /mnt/packages/$package/* .

  abuild -F checksum
  abuild -F -r -d

  cd ~
}

main