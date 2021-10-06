#!/bin/sh
set -e

host_uid=$1
host_gid=$2
arch=$3

# Kernel content:
# armhf => rpi, rpi2
# armv7 => rpi2, rpi4
# aarch64 => rpi, rpi4

# Packages:
# linux-rpi-dev => armhf, armv7, aarch64
# linux-rpi2-dev => armhf, armv7
# linux-rpi4-dev => armv7, aarch64

# Note: for now we only build for armhf

function main() {
  # we need that to pick last kernel
  apk update
  apk --no-cache add make gcc fakeroot squashfs-tools alpine-conf git tar

  # package description : "linux-rpi-dev-4.9.65-r0 description:", kernel version : "4.9.65-0"
  version=$(apk info linux-rpi-dev | grep description | grep -oE "\d+\.\d+\.\d+\-r\d+" | sed 's/r//g')

  working_directory=/build/kernel-update
  output_dir=/mnt/build/kernel

  extra_dir=$working_directory/extra-modules
  kernel_dir=$working_directory/kernel

  build_modules
  # modules are in $extra_dir
  setup_kernel
  # kernel is in $kernel_dir
  build_modloop
  # modloops are built in-place in $kernel_dir
  package

  finalize

  # debug
  # /bin/sh
}

function build_modules() {
  echo "BUILDING MODULES"

  local working_root_fs=$working_directory/root-fs
  local sources_dir=$working_directory/sources

  mkdir -p $working_root_fs
  fakeroot apk -p $working_root_fs add --initdb --no-scripts --update-cache alpine-base linux-rpi-dev linux-rpi2-dev --arch armhf --keys-dir /etc/apk/keys --repositories-file /etc/apk/repositories

  mkdir -p $extra_dir/rpi
  mkdir -p $extra_dir/rpi2

  git clone https://github.com/mylife-home/mylife-home-kmodules $sources_dir

  # AC
  local ac_sources_dir=$sources_dir/ac

  # rpi1
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$ac_sources_dir modules
  cp $ac_sources_dir/*.ko $extra_dir/rpi
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$ac_sources_dir clean

  # rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$ac_sources_dir modules
  cp $ac_sources_dir/*.ko $extra_dir/rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$ac_sources_dir clean

  # PWM
  local pwm_sources_dir=$sources_dir/pwm
  # rpi1
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$pwm_sources_dir MYLIFE_ARCH=MYLIFE_ARCH_RPI1 modules
  cp $pwm_sources_dir/*.ko $extra_dir/rpi
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi M=$pwm_sources_dir clean

  # rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$pwm_sources_dir MYLIFE_ARCH=MYLIFE_ARCH_RPI2 modules
  cp $pwm_sources_dir/*.ko $extra_dir/rpi2
  make -C $working_root_fs/usr/src/linux-headers-$version-rpi2 M=$pwm_sources_dir clean

  rm -rf $sources_dir
  rm -rf $working_root_fs
}

function setup_kernel() {
  echo "SETUPING KERNEL"

  update-kernel -a armhf -f rpi2 $kernel_dir
  update-kernel -a armhf -f rpi $kernel_dir
}

function build_modloop() {
  echo "BUILDING MODLOOPS"

  local working_root_fs=$working_directory/root-fs

  build_modloop_by_flavor rpi
  build_modloop_by_flavor rpi2

  rm -rf $extra_dir
}

function build_modloop_by_flavor() {

  local flavor=$1
  local modloop_name=modloop-$flavor
  local working_root_fs=$working_directory/root-fs
  local full_version=$version-$flavor

  mkdir -p $working_directory/new-$modloop_name

  # pick existing modules
  mkdir -p $working_directory/$modloop_name
  mount $kernel_dir/$modloop_name $working_directory/$modloop_name -t squashfs -o loop
  cp -r $working_directory/$modloop_name/* $working_directory/new-$modloop_name
  umount $working_directory/$modloop_name
  rmdir $working_directory/$modloop_name
  rm -f $kernel_dir/$modloop_name

  # pick new modules
  mkdir -p $working_directory/new-$modloop_name/modules/$full_version/extra
  cp -r $extra_dir/$flavor/* $working_directory/new-$modloop_name/modules/$full_version/extra

  # build squashfs
  mkdir -p $working_root_fs
  ln -s $working_directory/new-$modloop_name $working_root_fs/lib
  depmod -a -b $working_root_fs $full_version
  rm -rf $working_root_fs
  mksquashfs $working_directory/new-$modloop_name $kernel_dir/$modloop_name -comp xz -exit-on-error -all-root
  rm -rf $working_directory/new-$modloop_name
}

function package() {
  echo "PACKAGING"

  local root_fs=$working_directory/root

  mkdir -p $root_fs/boot
  cp -r $kernel_dir/dtbs/* $root_fs
  for flavor in rpi rpi2; do
    cp \
      $kernel_dir/System.map-$flavor \
      $kernel_dir/config-$flavor \
      $kernel_dir/initramfs-$flavor \
      $kernel_dir/modloop-$flavor \
      $kernel_dir/vmlinuz-$flavor \
      $root_fs/boot
  done

  tar --owner=root --group=root -C $working_directory -zcvf $output_dir/base-kernel-$version.tar.gz root

  rm -rf $working_directory
}

function finalize() {
  chown -R $host_uid:$host_gid /mnt/build/kernel
}

main