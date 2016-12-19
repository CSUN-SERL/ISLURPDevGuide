## Summary
It is important to install all the required dependencies before running any of the code presented in this repository. The required dependencies have been organized by their respective section of the project. As a start, you need to install Ubuntu 16.04 LTS 64-bit.

The following shell scripts automate most of the process for setting up the development environment for the project. `install-ros.sh` will download and install `ros-kinetic-desktop-full` and  `ros-kinetic-mavros`, which isn't included with desktop-full. `install-lcar-bot.sh` will download and install `libuvc` and `libusb` from source, followed by the `lcar-bot` code repository. The script will store the `lcar-bot` repository in `~/Documents`. If you are not working on the lcar-bot repository directly, you can skip running `install-lcar-bot.sh`. The next shell script, `install-px4.sh` will install the software required to run the PX4 simulation with gazebo.

To get started, save the shell script to your computer by right-clicking on the file name and choosing "Save Link As" or "Save Target As". Alternatively, you can copy and paste the contents of the shell script into a text editor of choice and save the file. Then open a new terminal, change directory to the same folder as the saved file, and run the following commands, one by one, in the terminal for each shell script (remember to change the file names appropriately).
```sh
chmod +x install-ros.sh
./install-ros.sh
```
Sit back and relax, the script will take some time to finish.

---
##### [install-ros.sh](install-ros.sh)
```sh

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

```
---

##### [install-lcar-bot.sh](install-lcar-bot.sh)
```sh

#-------------------------------libusb--------------------------------

islurp_deps_dir="$HOME/.islurp_deps"
mkdir -p $islurp_deps_dir

cd $islurp_deps_dir
file="$islurp_deps_dir/libusb.tar.bz2"
if [ ! -e $file ]; then
  wget -N -O libusb.tar.bz2 https://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.9/libusb-1.0.9.tar.bz2/download
fi

tar jxf $file
cd libusb-1.0.9
./configure
make
sudo make install
rm -rf "$islurp_deps_dir/libusb-1.0.9"

#-------------------------------libuvc-------------------------------

echo -e "\033[32m Installing libuvc\033[0m"

cd $islurp_deps_dir
file="$islurp_deps_dir/libuvc.tar.bz2"
if [ ! -d $file ]; then
  git clone https://github.com/ktossell/libuvc.git
  tar -cjf libuvc.tar.bz2 libuvc
  rm -rf "$islurp_deps_dir/libuvc"
fi

tar jxf $file
cd libuvc
mkdir -p build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local ..
make
sudo make install
rm -rf "$islurp_deps_dir/libuvc"

# /usr/local/include/libuvc/libuvc.h looks for libusb.h directly in an include
# directory (/usr/local/include/libusb.h), so we need to create a link there
# pointing to /usr/local/include/libusb-1.0/libusb.h
file="/usr/local/include/libusb.h"
if [ ! -e $file ]; then
  sudo ln -s /usr/local/include/libusb-1.0/libusb.h $file
fi

#------------------------------islurp---------------------------------

echo -e "\033[32m Cloning ISLURP repo\033[0m"

cd ~/Documents
dir="$HOME/Documents/lcar-bot"
if [ ! -d  $dir ]; then
  git clone https://github.com/csun-serl/lcar-bot.git
fi
cd $dir
catkin_make

setup_string="$HOME/Documents/lcar-bot/devel/setup.bash"
if ! grep -q "$setup_string" ~/.bashrc; then
  echo "source $setup_string" >> ~/.bashrc
  source ~/.bashrc
fi

# Lastly, we need to modify the udev rules for the stereo
file="/etc/udev/rules.d/li_stereo.rules"
if [ ! -e $file ]; then
  udev_rules='SUBSYSTEMS==\"usb\", ATTRS{manufacturer}==\"Leopard Imaging\", ATTRS{product}==\"LI-STEREO\", GROUP:=\"video\"'
  sudo sh -c "echo $udev_rules > $file"
fi

dir="$HOME/Documents/lcar-bot/resources"
sudo ln -s $dir/lcar-bot /usr/local/bin/lcar-bot
sudo ln -s $dir/lcar-fleet /usr/local/bin/lcar-fleet

echo -e "\033[32m DONE\033[0m"


```
---

##### [install_px4.sh] (install_px4.sh)

We need to test our code the PX4 firmware stack because the UAV's use it. Some considerate people decided to make a PX4 simulator that works with Gazebo.

This script was adapted from the dev guide at dev.px4.io. It contains the relevant parts of their guide for setting up the px4 firmware simulation that we need to test our UAV control code. the software will be installed to ~/Documents/PX4/Firmware.

```sh
echo -e "\033[32m Installing px4 firmware\033[0m"

#first take care of the dependencies
sudo add-apt-repository ppa:george-edison55/cmake-3.x -y
sudo apt-get update
sudo apt-get install python-argparse git-core wget zip \
    python-empy qtcreator cmake build-essential genromfs -y

# simulation tools
sudo apt-get install ant protobuf-compiler libeigen3-dev libopencv-dev openjdk-8-jdk openjdk-8-jre clang-3.5 lldb-3.5 -y

sudo apt-get remove modemmanager

sudo apt-get remove gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi
sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa
sudo apt-get update
sudo apt-get install python-serial openocd \
    flex bison libncurses5-dev autoconf texinfo build-essential \
    libftdi-dev libtool zlib1g-dev \
    python-empy gcc-arm-embedded -y

#building the code
cd ~/Documents
mkdir PX4 && cd PX4

git clone https://github.com/PX4/Firmware.git
cd Firmware
git submodule update --init --recursive

make px4fmu-v2_default

echo -e "\033[32m DONE\033[0m"
```

To run the software, Gazebo must be installed. It should have come with your
installation of ROS. to run the simulation:

```sh
cd ~/Documents/Firmware

make posix_sitl_default gazebo
```

Gazebo should launch with a single quad-rotor UAV in the middle
