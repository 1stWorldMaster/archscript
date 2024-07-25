countdown() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    echo -ne "Time remaining: $seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo "Time's up!"
}

#Post installation
unmount -lR /mnt
countdown 2
echo "Post-installation complete."

shutdown now