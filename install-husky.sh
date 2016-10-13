echo -e "\033[32m ----------Creating Workspace----------\033[0m"
mkdir ~/Documents/husky_kinetic
cd ~/Documents/husky_kinetic
wget https://raw.githubusercontent.com/CSUN-SERL/ISLURPDevguide/master/kinetic-husky-wet.rosinstall

echo -e "\033[32m ----------Downloading Source Code----------\033[0m"
# Get the source code
wstool init src kinetic-husky-wet.rosinstall

echo -e "\033[32m ----------Installing Dependencies----------\033[0m"
# Install Dependencies (ignore errors)
rosdep install --from-paths src --ignore-src --rosdistro kinetic -y -r

# Setup the catkin workspace
catkin_init_workspace
catkin_make

echo "source ~/Documents/husky_kinetic/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo -e "\033[32m ----------DONE----------\033[0m"

