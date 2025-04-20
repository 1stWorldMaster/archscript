cd blender
git checkout main
make update
git checkout issues
git pull origin main
cd ../build_linux
ninja install
notify-send "Blender-update" "Your blender update is complete"
