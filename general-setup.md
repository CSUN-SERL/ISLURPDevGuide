## Summary
It is important to install all the required dependencies before running any of the code presented in this repository. The required dependencies have been organized by their respective section of the project. As a start, you need to install Ubuntu 16.04 LTS 64-bit.

The following two shell scripts automate most of the process for setting up the development environment for the project. `install-ros.sh` will download and install `ros-kinetic-desktop-full` and  `ros-kinetic-mavros`, which isn't included with desktop-full. `install-lcar-bot.sh` will download and `libuvc` and `libusb` from source, followed by `lcar-bot`. `lcar-bot` is located in `~/Documents`. If you are not working on the lcar-bot repository directly, you can skip running `install-lcar-bot.sh`.

To get started, open a text editor of choice, copy each script into its own file. Save the first as `install-ros.sh` in `~/Documents`. Save the second as `install-lcar-bot.sh` to the same directory. Then open a new terminal and type `chmod +x install-ros.sh install-lcar-bot.sh`. Lastly, type `./install-ros.sh` and hit enter, followed by `./install-lcar-bot.sh` is installing the `lcar-bot` repository. Sit back and relax, the script will take some time to finish.

##### [install-ros.sh](install-ros.sh)
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

sudo apt install libusb-dev

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
  sudo ln /usr/local/include/libusb-1.0/libusb.h $file
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
