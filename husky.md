
The Husky ground rover is not supported by default on ros-kinetic, but the
source code is available for download, compilation and installation into ROS.
This script does that. dont forget to `chmod +x install-husky.sh` first.

##### [install-husky.sh](install-husky.sh)
```sh

# from apt:
# ros-kinetic-control*
# ros-kinetic-robot-localization
# ros-kinetic-interactive-marker*

# from source:
#   interactive-marker-twist-server
#   husky
islurp_deps_dir="$HOME/.islurp_deps"
mkdir -p $islurp_deps_dir

opt_dir="/opt/ros/kinetic_src"
sudo mkdir -p $opt_dir
sudo chown $USER.$USER $opt_dir

file="/etc/ros/rosdep/sources.list.d/20-default.list"
if [ ! -e $file ]; then
  sudo rosdep init
fi
rosdep update
sudo apt install -y ros-kinetic-control* ros-kinetic-robot-localization ros-kinetic-interactive-marker* ros-kinetic-twist-mux

file="$islurp_deps_dir/husky.tar.bz2"
catkin_space="$islurp_deps_dir/husky"
if [ ! -e $file ]; then
  mkdir -p "$catkin_space/src"
  cd "$catkin_space/src"
  git clone https://github.com/husky/husky.git
  git clone https://github.com/ros-visualization/interactive_marker_twist_server
  cd $islurp_deps_dir
  tar -cjf $file husky
  rm -rf $catkin_space
fi

tar -jxf $file
cd "$catkin_space/src"
catkin_init_workspace
cd ..
catkin_make -DCMAKE_INSTALL_PREFIX=$opt_dir install

rm -rf $catkin_space

setup_string="$opt_dir/setup.bash"
if ! grep -q "$setup_string" ~/.bashrc; then
  echo "source $opt_dir/setup.bash" >> ~/.bashrc
fi

echo -e "\033[32m DONE\033[0m"


```
