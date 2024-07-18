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