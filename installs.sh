echo "Testing"

neofetch

#Timer Function
echo "Starting 5-second timer..."
sleep 5
echo "Timer expired!"

clear

echo "Type the password for sudo account"
passwd

echo "Type the user name "
read user_name

useradd -m -g users -G wheel, storage,power,video,audio -s /bin/bash "$user_name"

echo "Type the user passwd"
passwd "$user_name"

echo "Uncomment the line with wheel may be 3rd last line"

#Timer Function
echo "Starting 5-second timer..."
sleep 5
echo "Timer expired!"

EDITOR= nano visudo

su "$user_name"

clear

sudo pacman -Syu

exit

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