#!/bin/sh
set -e

host_uid=$1
host_gid=$2

function main() {
  apk update
  setup_abuild

  build_package mylife-home-core
  build_package mylife-home-core-plugins-driver-absoluta
  build_package mylife-home-core-plugins-driver-broadlink
  build_package mylife-home-core-plugins-driver-lirc
  build_package mylife-home-core-plugins-driver-mpd
  build_package mylife-home-core-plugins-driver-sensors
  build_package mylife-home-core-plugins-driver-sysfs
  build_package mylife-home-core-plugins-driver-tahoma
  build_package mylife-home-core-plugins-logic-base
  build_package mylife-home-core-plugins-logic-clim
  build_package mylife-home-core-plugins-logic-colors
  build_package mylife-home-core-plugins-logic-selectors
  build_package mylife-home-core-plugins-logic-timers
  build_package mylife-home-core-plugins-ui-base
  build_package lirc true

  finalize

  # debug
  # /bin/sh
}

function setup_abuild() {
  # add deps to build node native modules
  apk add --no-cache sudo git alpine-sdk nodejs npm python3

  mkdir -p /var/cache/distfiles
  chmod a+w /var/cache/distfiles

  mkdir -p ~/.ssh
  cp -r /mnt/build-secrets/ssh-keys/* ~/.ssh/
  chmod 700 ~/.ssh

  mkdir -p ~/.abuild
  cp /mnt/build-secrets/abuild/* ~/.abuild
  cp ~/.abuild/*.rsa.pub /etc/apk/keys

  mkdir -p ~/packages
  ln -s /mnt/build/packages ~/packages/build
  mkdir ~/build # this folder will serve as output subdirectory
}

function finalize() {
  chown -R $host_uid:$host_gid /mnt/build/packages
}

function build_package() {
  local package=$1
  local with_deps=$2

  mkdir ~/build/$package
  cd ~/build/$package
  cp -r /mnt/packages/$package/* .

  # TODO: deal with multiple subpackages
  local arch=$(abuild -A)
  local apk=$(abuild -F listpkg)

  mkdir -p ~/packages/build/$arch

  if wget -P ~/packages/build/$arch $CURRENT_REPO/$arch/$apk; then
    echo "used CURRENT_REPO cached $package"
    abuild -F index
    cd ~
    return
  fi

  abuild -F checksum

  if [ "$with_deps" = "true" ]; then
    abuild -F -r
  else
    abuild -F -r -d
  fi

  cd ~
}

main