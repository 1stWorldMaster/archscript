#!/bin/bash
countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -ne "Time remaining: $seconds\033[0K\r"
        sleep 1
        : $((seconds--))
    done
    echo -e "\nTime's up!"
}

home(){
	cd ~/projects/blender-git/
}

# Setting up the timer 
start_time=$(date +%s)

# Installing the git Updates
notify-send "Blender" "Enter your password in window 1"
sudo pacman -S --noconfirm base-devel subversion cmake libepoxy libxi libxcursor libxrandr libxinerama libxxf86vm python wayland-protocols libxkbcommon libdecor
home
notify-send "Blender" "Starting the download from the git repo and other dependencies"
git clone --depth 1 https://projects.blender.org/blender/blender.git
cd blender

# Downloading libraries
notify-send "Blender" "Starting with loding external libs"
echo "Waiting for checking of something"
./build_files/utils/make_update.py --use-linux-libraries

notify-send "Blender" "Building blender has started"
echo "Check the updates"
make update
notify-send "Blender" "Checking and making the files"
make

end_time=$(date +%s)
runtime=$((end_time - start_time))
echo "The script ran for $runtime seconds."
notify-send "Blender" "The program is build in $runtime"

