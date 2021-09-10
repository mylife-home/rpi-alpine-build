#!/bin/sh
set -e

host_uid=$1
host_gid=$2

function main() {

  finalize

  # debug
  # /bin/sh
}

function finalize() {
  chown -R $host_uid:$host_gid /mnt/build/*
}