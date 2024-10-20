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

nmcli dev status
nmcli radio wifi on
nmcli dev wifi list

echo "Write the wifi name"

countdown 5

while true; do
    echo "Write the wifi password"
    read wifiname
    countdown 5
    echo "Write the password for that wifi"
    read pass
    sudo nmcli dev wifi connect "$wifiname" password "$pass"
    if [ $? -eq 0 ]; then
        break
    else
        echo "Script failed. Retrying..."
    fi
done


sudo pacman -Syu
sudo pacman -S gnome gnome-tweaks gnome-shell-extensions


echo "Enabling and starting services..."


sudo systemctl enable gdm
sudo systemctl start gdm
