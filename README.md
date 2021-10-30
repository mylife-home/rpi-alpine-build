# rpi-alpine-build
MyLife Home alpine build on raspberry pi

## Usage

### Build packages (all arch)

- Will use package images from npm (if needed bump versions in `APKBUILD`s)
- Bump `DOCKER_PACKAGES_REPOSITORY_VERSION`
```
CURRENT_REPO=http://.../alpine scripts/build-packages.sh
```
- Docker image for package repository will be published.
- Bump k8s deployment image version (`packages-repository`)

### Build kernel modules (armhf only for now)

- modules repository will be cloned from master branch
```
scripts/build-kernel.sh
```
- Output will be produced in `build/kernel/base-kernel-{version}-{arch}.tar.gz` + config files
- Copy it into studio files

## Docs

- docker rpi emulation
  - https://hub.docker.com/r/rycus86/armhf-alpine-qemu
  - alpine qemu arm aarch64: https://superuser.com/questions/1397991/running-alpine-linux-on-qemu-arm-guests
  - docker pi for raspbian: https://github.com/lukechilds/dockerpi
  - custom qemu raspbian kernel: https://github.com/dhruvvyas90/qemu-rpi-kernel
  - cross-platform build tools: https://github.com/DDoSolitary/alpine-repo - https://github.com/DDoSolitary/alpine-repo/tree/docker
- open-rc daemon
  - https://stackoverflow.com/questions/8251933/how-can-i-log-the-stdout-of-a-process-started-by-start-stop-daemon
  - https://wiki.alpinelinux.org/wiki/Writing_Init_Scripts
  - https://wiki.gentoo.org/wiki/OpenRC/supervise-daemon#Services_which_won.27t_run_under_a_supervisor
  - https://github.com/OpenRC/openrc/blob/master/supervise-daemon-guide.md
- alpine repository
  - https://www.erianna.com/creating-a-alpine-linux-repository/
- nrpe ?
- ancien setup: https://github.com/vincent-tr/rpi-image-builder/

## Rpi config initialization
- install base image on SD Card
- boot (with monitor and keyboard)
- Login root
- setup-alpine
    ```
    Keyboard layout: none (default)
    Hostname: todo-hostname
    Init interface : eth0 (default)
    IP adress: dhcp (default)
    Init interface: done (pas wlan0)
    Manuel net config: no (default)
    New pass for root: ###
    Timezone: Europe/Paris
    Proxy URL : none (default)
    Ntp client : chrony (default)
    Mirror URL: 1 (default)
    Ssh server: openssh (default)
    No available disk. Umount: no (default)
    Enter where to store config : mmcblk0p1 (default)
    Enter apk cache directory: /media/mmcblk0p1/cache (default)
    ```
- config sshd
  - vi /etc/ssh/sshd_config
      ```
      PermitRootLogin yes
      ```
  - service sshd restart
  - lbu commit
- add authorized keys:
  - cd /root
  - mkdir .ssh
  - chmod 700 .ssh
  - cd .ssh
  - cat > authorized_keys
  - <add pub key>
  - ctrl+D
  - chmod 600 authorized_keys
  - lbu add /root/.ssh/authorized_keys
  - lbu commit
- add custom repository
  - cat > /etc/apk/keys/mylife-home-builder.rsa.pub
  - <copy studio-data/build-secrets/abuild/mylife-home-builder.rsa.pub>
  - ctrl+D
  - echo "http://mylife-home-packages.apps.mti-team2.dyndns.org/alpine" >> /etc/apk/repositories
- reboot # (to be sure all is ok)
- at the end, retrieve the `/media/mmcblk0p1/todo-hostname.apkovl.tar.gz` file, it is config base
- locally:
  - mkdir root
  - put the `apkovl.tar.gz` file in root (note: archive content files/dirs must be owned by root/wheel (uid 0, gid 0))
  - tar -zcvf base-config.tar.gz root
  - upload `base-config.tar.gz` to studio files

## Install

### From Windows

- https://github.com/garrym/raspberry-pi-alpine
  - dans le gestionnaire de disque, supprimer les partitions existantes
  - creer une partition FAT32 de taille max, label: "rpi-alpine"
  - copier/coller le contenu du .tar.gz
- alt: sous windows il faut formatter la SD Card avec Rufus (sinon ca boot, mais le layout de /dev/mmblck*** est faux)

### Recreate wrong partition online

- apk add cfdisk dosfstools
- umount /.modloop
- umount /media/mmcblk0 (ou /media/mmcblk0p1, depend dans la mauvaise partition)
- cfdisk
  - supprimer l'existant
  - creer table 'dos'
  - creer partition (max size)
  - changer type en c (FAT32 LBA)
  - write 'yes'
- mkdosfs -F32 /dev/mmcblk0p1
- mount /dev/mmcblk0p1 /media/mmcblk0p1
- redeployer image alpine

## TODO

- pourquoi root/dtb a la racine dans l'image de base, et dans des sous-dossiers dans l'update de kernel ?
- cache
  - rajouter env var : CURRENT_REPOSITORY=http://...
  - pour chaque build de package, aller construire sa target et essayer de le DL du repo. si c'est OK, pas de build, sinon build comment actuellement
