# rpi-alpine-build
MyLife Home alpine build on raspberry pi

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
 - vi /etc/ssh/sshd_config
    ```
    PermitRootLogin yes
    ```
 - service sshd restart
 - lbu commit
 - reboot # (to be sure all is ok)
 - at the end, retrieve the `/media/mmcblk0p1/todo-hostname.apkovl.tar.gz` file, it is config base

## Install

### From Windows

 - https://github.com/garrym/raspberry-pi-alpine
   - dans le gestionnaire de disque, supprimer les partitions existantes
   - creer une partition FAT32 de 4096MB, label: "rpi-alpine"
   - copier/coller le contenu du .tar.gz
 - alt: sous windows il faut formatter la SD Card avec Rufus (sinon ca boot, mais le layout de /dev/mmblck*** est faux)

## TODO

- produire une image docker qui contient un web statique avec le repo APK ? comment gerer le fait d'avoir plusieurs versions de packages ?
   -- ou --
- host un nginx, avec un volume persistent, et ajouter de quoi upload dessus les resultats de build (+ index automatique ?)

- integrer les drivers:
  - https://github.com/mylife-home/mylife-home-drivers-pwm
  - https://github.com/mylife-home/mylife-home-drivers-ac


=> TODO pour livrer core avec irc-bridge dessus:
 - creer taches de deploy pour essayer de creer l'image
 - tester
