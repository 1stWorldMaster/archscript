countdown() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    echo -ne "Time remaining: $seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo "Time's up!"
}


echo "Testing"
neofetch
countdown 9

clear

echo "Type the password for sudo account"
passwd
countdown 3

echo "Type the user name "
read user_name
countdown 5
useradd -m -g users -G wheel,storage,power,video,audio -s /bin/bash "$user_name"
countdown 3
echo "Type the user passwd"
passwd "$user_name"
countdown 3

clear
echo "Uncomment the line with wheel may be 3rd last line"

countdown 5

EDITOR=nano visudo

ln -sf /ur/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# Localization
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Network configuration
echo "archlinux" > /etc/archlinux
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 myhostname.localdomain archlinux" >> /etc/hosts


# Install and configure GRUB
pacman -S --noconfirm grub efibootmgr dosfstools mtools
lsblk
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable essential services
systemctl enable bluetooth
systemctl enable NetworkManager

exit