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

sudo pacman -S --noconfirm firefox alsa-utils pavucontrol code neovim clang unzip wget gdb
sudo pacman -S --noconfirm nvidia-open
nvidia-smi
countdown (5)
echo "Do verify the command for the nvidia-smi"
sudo pacman -S --noconfirm gimp vlc libreoffice

# Instllation of yay
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..