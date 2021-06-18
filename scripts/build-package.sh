#!/bin/sh

package=$1

mkdir ~/build/$package
cd ~/build/$package
cp -r /mnt/packages/$package/* .

abuild -F checksum
abuild -F -r

cd ~
