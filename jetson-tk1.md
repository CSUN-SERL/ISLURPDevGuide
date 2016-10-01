## Jetson TK1 Setup
![](/assets/jetson-tk1.jpg)
For the companion computer, we'll be using the [Jetson TK1](https://developer.nvidia.com/embedded-computing). The Jetson comes pre-installed with Ubuntu 14.04. However, some initial setup has to be completed before it is ready to be integrated into the system. This section details the necessary steps.

####Installing ROS
Since, at the time of writing, Ubuntu 16.04 is not available for the Jetson TK1, ROS Kinetic must be compiled from source.

####Modifying Sources List
First, change the repository list on the Jetson to get the proper arm packages. The default list results in some missing arm packages. Add the sources listed below to get the proper packages.

>More information on adding repositories can be found on Ubuntu's site [here](https://help.ubuntu.com/community/Repositories/Ubuntu)

```
deb http://ports.ubuntu.com/ubuntu-ports/ trusty main
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty main
deb http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-updates main
deb http://ports.ubuntu.com/ubuntu-ports/ trusty-security main
deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-security main

```
Once the sources list has been updated, fire up the terminal and update the package list by running `sudo apt-get update`. Once achieved, install `ros-indigo-base` according to the (ROS Wiki)[http://wiki.ros.org/NvidiaJetsonTK1]. The lcar-bot shell script detailed above in the Summary section can now be followed to install the rest of the dependencies.