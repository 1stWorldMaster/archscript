# ---ARCH INSTALLER SCRIPT---
countdown() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    echo -ne "Time remaining: $seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo "Time's up!"
}

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

pacman -Sy
pacman -Sy archlinux-keyring


clear
lsblk #command to view the file 
echo "Press Enter to continue..."
read

get_device_name
countdown 1
cfdisk "$device_name"
countdown 5

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

countdown 5
echo "Do verify if the drives are mounted properly "
lsblk
echo "Press enter to continue "
read

pacstrap -i /mnt base base-devel linux linux-firmware git sudo neofetch htop amd-ucode nano vim bluez bluez-utils networkmanager
echo "Press Enter to continue"
read
clear

lsblk
echo "Further mounting to take place"
countdown 5
echo "Press enter to continue "
read

genfstab -U /mnt >> /mnt/etc/fstab 
cat /mnt/etc/fstab
countdown 5
clear


arch-chroot /mnt 