#!/bin/sh
set -e

host_uid=$1
host_gid=$2

function main() {
  apk update
  setup_abuild

  build_package mylife-home-core-go

  finalize

  # debug
  # /bin/sh
}

function setup_abuild() {
  # add deps to build node native modules
  apk add --no-cache sudo git alpine-sdk

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

  abuild -F -r

  cd ~
}

main