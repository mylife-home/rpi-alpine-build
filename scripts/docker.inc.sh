function docker_init() {
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes
}

function docker_run_platforms() {
  local build_platform=$1

  build_platform arm64v8 arm64 # aarch64 (rpi2 V1.2, rpi3, rpi4)
  build_platform arm32v6 arm # armhf (rpi1, rpi0, rpi0w)
  build_platform arm32v7 arm # armv7l (rpi2 V1.1)
}
