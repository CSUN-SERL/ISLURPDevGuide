
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
