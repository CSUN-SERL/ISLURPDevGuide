## Summary
It is very important to install all the required dependencies before running any of the code presented in this repository. The required dependencies have been organized by their respective section of the project. As a start, we recommend installing Ubuntu 14.04 LTS 64-bit.

The following shell script automates most of the process for setting up the development environment for the project. If your Linux installation is free of ROS and OpenCV, you can just run the script to install all the dependencies. 

In short, the following script will download and install `ros-indigo-desktop`, `opencv-3.0` and its' dependencies, and `libuvc` from source and its' dependencies. All downloaded files are located in `~/lcar-bot-files`. The only thing left to do at that point is to navigate to `~/lcar-bot-files`, clone the lcar-bot repository, and run catkin_make inside the `lcar-bot` folder. 
To get started, open a text editor of choice, copy the script into it and save it as `install-lcar-bot.sh` to your home directory and close. Then open a new terminal and type `chmod +x install-lcar-bot.sh`. Lastly, type `./install-lcar-bot.sh` and hit enter. Sit back and relax, the script will take some time to finish.

_Note: If you have already installed `ros-indigo-desktop-full` instead of `ros-indigo-desktop`, it is best to completely uninstall ROS and reinstall the correct version of ROS. Same goes for OpenCV. If you have version 2.4 of OpenCV installed, it's best to remove that as well. To purge your system of ROS and OpenCV before running the script, run `sudo apt-get purge ros-*`, `sudo apt-get purge libopencv`, and `sudo apt-get autoremove` in the terminal, respectively._

##### install-lcar-bot.sh
``` shell
# Install ros-indigo-desktop (not full) by following the tutorial from the ROS wiki
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
apt-get update
apt-get install -y ros-indigo-desktop
rosdep init
rosdep update
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc
apt-get install -y ros-indigo-mavros python-rosinstall ros-indigo-image-transport

#-------------------------------libusb--------------------------------
mkdir -p ~/lcar-bot-files
cd ~/lcar-bot-files
wget -N -O libusb.tar.bz2 https://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.9/libusb-1.0.9.tar.bz2/download
tar jxf libusb.tar.bz2
cd libusb-1.0.9
./configure
make
make install

#-------------------------------libuvc-------------------------------
cd ~/lcar-bot-files
git clone https://github.com/ktossell/libuvc.git
cd libuvc
mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local ..
make
make install

#-------------------------------OpenCV-------------------------------
# Install OpenCV dependencies first
apt-get install -qq -y libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils ffmpeg cmake qt5-default checkinstall
wget -N -O opencv-3.0.0.zip http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.0.0/opencv-3.0.0.zip/download
unzip opencv-3.0.0.zip -d ~/lcar-bot-files
cd ~/lcar-bot-files/opencv-3.0.0
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_GTK=ON -D WITH_TBB=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_OPENGL=ON ..
make -j$(nproc)
make install

echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
ldconfig

cd ~/lcar-bot-files
git clone https://github.com/kPanesar/lcar-bot.git
cd lcar-bot
source ~/.bashrc
catkin_make
source ~/lcar-bot-files/lcar-bot/devel/setup.bash

cd ~/
chown -R $USER lcar-bot-files/

```

Lastly, we need to modify the udev rules. Add the following code to a new file called `LI_Stereo.rules` and save it in the `/etc/udev/rules.d` directory:

```
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Leopard Imaging", ATTRS{product}=="LI-STEREO", GROUP:="video"
```


The following is a list of updated packages to ensure that:
     1. Your installation does not have any OpenCV-2.4 dependencies
     2. Your installation will work with OpenCV-3.0
        (At the time of this writing stereo_image_proc needed to be manually updated to work with OpenCV-3.0)

```
GCS
From apt-get:
	ros-indigo-ros-base (avoiding opencv 2.4)
	ros-indigo-tf
	ros-indigo-tf2
	ros-indigo-tf2-geometry-msgs
	ros-indigo-angles
	ros-indigo-geometry-msgs
    ros-indigo-mavros 
	ros-indigo-qt-gui
	ros-indigio-qt-gui-cpp
	ros-indigo-camera-calibration-parsers
	ros-indigo-camera-info-manager
	ros-indigo-image-transport
	ros-indigo-eigen-conversions
	ros-indigo-rosbridge
	
From github:
	image_pipeline (edit to work with opencv-3)
	url: https://github.com/ros-perception/image_pipeline.git

	vision_opencv 
	url: https://github.com/mikejmills/vision_opencv.git

	rqt
	url: https://github.com/ros-visualization/rqt.git

On the jetson
	apt-get:
		Ros-indigo-mavros
		Ros-indigo-mavros-extras
                …. All packages from GCS except rqt
         ]
        github:
                Same as above but without rqt         
```