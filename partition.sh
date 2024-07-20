# ---ARCH INSTALLER SCRIPT---

# Function to prompt for device name
get_device_name() {
  while true; do
    echo "Please enter the device name (e.g., /dev/sda):"
    read device_name

    # Check if the device name is not empty
    if [ -n "$device_name" ]; then
      break
    else
      echo "No device name entered. Please try again."
    fi
  done
}

clear

echo "Lets view the disk file"
lsblk #command to view the file 
echo "Press Enter to continue..."
read

# Function call to get the device name to continue the installation
get_device_name

# Use the entered device name with cfdisk
cfdisk "$device_name"

clear

#Again give the instructions
lsblk


# Get the device names
echo "Please enter the device name for the EFI partition (e.g., /dev/sda1):"
read efi_disk

echo "Please enter the device name for the main partition (e.g., /dev/sda2):"
read main_disk

echo "Please enter the device name for the swap partition (e.g., /dev/sda3):"
read swap_disk

# Format the disks
mkfs.fat -F32 "$efi_disk"
mkfs.ext4 "$main_disk"
mkswap "$swap_disk"

clear
lsblk

mount "$main_disk" /mnt 
mkdir /mnt/boot
mount "$efi_disk" /mnt/boot
swapon "$swap_disk"

clear
lsblk

pacstrap -i /mnt base base-devel linux linux-firmware sudo git neofetch htop amd-ucode nano vim bluez bluez-utils networkmanager

clear
lsblk

genfstab -U /mnt >> /mnt/etc/fstab 
cat /mnt/etc/fstab

#Timer Function
echo "Starting 5-second timer..."
sleep 5
echo "Timer expired!"

clear

arch-chroot /mnt

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