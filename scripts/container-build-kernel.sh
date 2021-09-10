#!/bin/sh
set -e

host_uid=$1
host_gid=$2
arch=$3

function main() {

  echo $(uname -a)

  finalize

  # debug
  # /bin/sh
}

function finalize() {
  chown -R $host_uid:$host_gid /mnt/build/*
}

main