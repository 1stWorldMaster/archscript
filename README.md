# ARCH SCRIPT
It provides the easy way to download the arch linux and setup the enviornment this is for coders you have install the arch automatically and also don't wany to use archinstall

## Setting up the Network
1. Open the iwctl terminal
```bash
iwctl
```
2. To see the device list
```bash
device list
```
expected output
```bash
#                            Devices
# -------------------------------------------------------------
#   Name          Address          Powered    Adapter    Mode
# -------------------------------------------------------------
#   wlan0         ...              on         ...        ...
```

3. To connect to any network
```bash
station YOURDEVICE connect YOURSSID
```

## Installing GIT
Need to install the git to downlaod the actual scipt to the PC 
```bash
pacman -S git
git clone https://github.com/1stWorldMaster/archscript
chmod +x partition.sh
/partition.sh
```

## Running Script
Run the files in the following order
1. partition.sh
2. install.sh
3. post-install.sh
4. setup.sh
 
### 1. partition.sh
Contains the command to make the partition for efi, linux and swap partition
expected it to be efi - 800MB, Linux-95GB and swap - 4.2 GB

### 2. install.sh
Downlaods the important module like vim, bluetooth, nano to make sure everything works properly

### 3. post-install.sh
unmount the partition which was installed in install time 

### 4. setup.sh
It will setup all the other utils for gnome to function properly