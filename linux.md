## Summary
It is very important to install all the required dependencies before running any of the code presented in this repository. The required dependencies have been organized by their respective section of the project. As a start, we recommend installing Ubuntu 14.04 LTS 64-bit.

The following shell script automates most of the process for setting up the development environment for the project. If your Linux installation is free of ROS and OpenCV, you can just run the script to install all the dependencies.

In short, the following script will download and install `ros-kinetic-desktop-full`  and `libuvc` from source. All downloaded files are located in `~/Documents`.
To get started, open a text editor of choice, copy the script into it and save it as `install-lcar-bot.sh` to `~/Documents` and close. Then open a new terminal and type `chmod +x install-lcar-bot.sh`. Lastly, type `./install-lcar-bot.sh` and hit enter. Sit back and relax, the script will take some time to finish.

##### install-lcar-bot.sh
```sh

echo -e "\033[32m Installing ROS Kinetic\033[0m"

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
sudo apt update
sudo apt install -y ros-kinetic-desktop-full ros-kinetic-mavros*
sudo rosdep init
rosdep update
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt install -y python-rosinstall

#-------------------------------libusb--------------------------------

mkdir -p ~/islurp-files
cd ~/islurp-files
wget -N -O libusb.tar.bz2 https://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.9/libusb-1.0.9.tar.bz2/download
tar jxf libusb.tar.bz2
cd libusb-1.0.9
./configure
make
sudo make install

#-------------------------------libuvc-------------------------------

echo -e "\033[32m Installing libuvc"

cd ~/islurp-files
git clone https://github.com/ktossell/libuvc.git
cd libuvc
mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local ..
make
sudo make install

#------------------------------islurp---------------------------------

echo -e "\033[32m Cloning ISLURP repo\033[0m"

cd ~/Documents
git clone https://github.com/csun-serl/lcar-bot.git
cd lcar-bot
source ~/.bashrc
echo "source ~/Documents/lcar-bot/devel/setup.bash" >> ~/.bashrc

# Lastly, we need to modify the udev rules. Add the following code to a new file called `LI_Stereo.rules` and save it in the `/etc/udev/rules.d` directory:

sudo echo "SUBSYSTEMS=='usb', ATTRS{manufacturer}=='Leopard Imaging', ATTRS{product}=='LI-STEREO', GROUP:='video'" > /etc/udev/rules.d/li_stereo.

# ----------------------------DONE-----------------------------------

sudo rm -rf ~/islurp-files
echo -e "\033[32m DONE\033[0m"

```
