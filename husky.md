```sh
# husky installation from source
# from apt:
# ros-kinetic-control*
# ros-kinetic-robot-localization
# ros-kinetic-interactive-marker*

# from source:
#   interactive-marker-twist-server
#   husky

opt_dir="/opt/ros/kinetic_src"
sudo mkdir -p $opt_dir
sudo chown $USER.$USER $opt_dir

# rosdep update
sudo apt install -y ros-kinetic-control* ros-kinetic-robot-localization ros-kinetic-interactive-marker* ros-kinetic-twist-mux

catkin_space="$HOME/Documents/husky"
mkdir -p "$catkin_space"
mkdir -p "$catkin_space/src"
cd "$catkin_space/src"
catkin_init_workspace
git clone https://github.com/husky/husky.git
git clone https://github.com/ros-visualization/interactive_marker_twist_server
cd ..
catkin_make -DCMAKE_INSTALL_PREFIX="$opt_dir" install

sudo rm -rf $catkin_space

echo "source $opt_dir/setup.bash" >> ~/.bashrc
```
