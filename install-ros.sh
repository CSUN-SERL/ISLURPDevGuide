echo -e "\033[32m Installing ROS Kinetic\033[0m"

file="/etc/apt/sources.list.d/ros-latest.list"
if [ ! -f  $file ]; then
  sudo sh -c "echo 'deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main' > $file"
fi

key=0xB01FA116
if ! apt-key list | grep -q $key; then
  sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key $key
fi

sudo apt update
sudo apt install -y ros-kinetic-desktop-full ros-kinetic-mavros*

file="/etc/ros/rosdep/sources.list.d/20-default.list"
if [ ! -e $file ]; then
  sudo rosdep init
fi

rosdep update

setup_string="/opt/ros/kinetic/setup.bash"
if ! grep -q "$setup_string" ~/.bashrc ; then
  echo "source $setup_string" >> ~/.bashrc
  source ~/.bashrc
fi
sudo apt install -y python-rosinstall

echo -e "\033[32m DONE\033[0m"
