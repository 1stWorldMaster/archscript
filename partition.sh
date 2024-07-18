echo "Lets view the disk file"
lsblk #command to view the file 
echo "Press Enter to continue..."
read

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

# Function call to get the device name to continue the installation
get_device_name

# Use the entered device name with cfdisk
cfdisk "$device_name"

# Unset the device_name variable to release the memory
unset device_name

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

pacstrap -i /mnt base base-devel linux linux-firmware sudo neofetch htop amd-ucode nano vim bluez bluez-utils networkmanager

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
