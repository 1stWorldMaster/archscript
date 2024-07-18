#Post installation

ln -sf /ur/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# Localization
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Network configuration
echo "myhostname" > /etc/archlinux
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 myhostname.localdomain archlinux" >> /etc/hosts


# Install and configure GRUB
pacman -S --noconfirm grub efibootmgr dosfstools mtools
lsblk
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id-GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable essential services
systemctl enable bluetooth
systemctl enable networkmanager

exit 

unmount -lR /mnt

echo "Post-installation complete. Exit chroot and reboot."

shutdown now