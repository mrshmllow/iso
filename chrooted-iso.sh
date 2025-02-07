#!/usr/bin/env bash
echo "Chrooted in the new system, running as $(whoami)"

# Compile GSchemas
glib-compile-schemas /usr/share/glib-2.0/schemas

# User setup
useradd -mG wheel crystal
usermod -c "Password // \"crystal\"" crystal
usermod -p $(echo "crystal" | openssl passwd -6 -stdin) crystal
usermod -p $(echo "crystal" | openssl passwd -6 -stdin) root
chsh -s /usr/bin/zsh crystal

# Install Jade's GUI
flatpak install -y --noninteractive /usr/share/jade-gui/jade-gui.flatpak

# Desktop icon for Jade's GUI
mkdir -p /home/crystal/Desktop
cp \
  /var/lib/flatpak/exports/share/applications/al.getcryst.jadegui.desktop \
  /home/crystal/Desktop/Install.desktop
chown -R crystal:crystal /home/crystal/

# Services
systemctl enable NetworkManager
systemctl enable gdm

# Mirrorlist
reflector > /etc/pacman.d/mirrorlist

# Hostname
echo "crystal-live" > /etc/hostname

# Locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen

echo "Configured the system. Exiting chroot."
