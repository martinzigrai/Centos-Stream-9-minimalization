dnf config-manager --set-enabled crb
dnf install epel-release epel-next-releas

chmod +x scrip.sh
./script.sh

# Install arora
dnf -y install arora

# Xorg
dnf -y install xorg-x11-server-Xorg xinit

# mupdf
dnf -y install mupdf

# window manager
dnf -y install twm

echo "xterm & exec twn" > .xinitrc

reboot
