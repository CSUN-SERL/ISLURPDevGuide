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
