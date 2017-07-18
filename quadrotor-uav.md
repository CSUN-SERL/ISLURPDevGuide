## Quadrotor Summary

This page covers the setup process for Quadrotor UAVs. Quadrotors have 4 propellers and two onboard computers, the Nvidia Jetson TK1 and the Pixhawk Flight Controller. The Nvidia Jetson TK1 is mostly responsible for managing motion tracking data of the vehicle and the Pixhawk is responsible for using sensors and controlling the vehicle. The quadcopters use OptiTrack motion tracking cameras for positioning during indoor missions and GPS for positioning during outdoor missions.

## Companion Computer Setup

![](/assets/Jetson-TK1_500.png)

**Companion Computer Nvidia Jetson TK1 Specifications:**

* CPU: Quad-Core Arm Cortex A15
* 2 GB x16 Memory with 64-bit Width
* 16 GB 4.51 eMMC Memory
* 1 Full-Size HDMI Port
* 1 USB 3.0 Port, A

_See more at \_\__\[\_Nvidia's Website_\]\([http:\/\/www.nvidia.com\/object\/jetson-tk1-embedded-dev-kit.html](http://www.nvidia.com/object/jetson-tk1-embedded-dev-kit.html)\)

#### Connecting the Jetson TK1 to the Pixhawk

1. The first step is to create a serial connection between the Pixhawk and the Jetson TK1. For this, we can use an FTDI cable with some modification to connect the _Telem 2_ port on the Pixhawk to the _USB_ port on the Jetson. Figure 1 details the connection between these two ports.

![](/assets/Jetson_to_Pixhawk.png)

_Note: Ensure that the SYSID\_THISMAV parameter on the FCU firmware matches the tgt\_system in the launch file for running mavros. If the two do not agree, some topic will not be published and\/or mavros will not work properly._

## Tuning Parameters

Testing with a live vehicle introduces a lot of sensor noise and therefore more drift. This can be alleviated to a certain extent by tuning the vehicle properly. On the PX4 flight stack, the following parameters should be tuned carefully:

* LNDMC\_THR\_MAX: Multicopter max throttle
* MPC\_Z\_VEL\_MAX: Maximum vertical velocity in AUTO mode and endpoint for stabilized modes \(ALTCTRL, POSCTRL\).
* [INAV\_W\_Z\_BARO](https://pixhawk.org/firmware/parameters#position_estimator_inav): Weight \(cutoff frequency\) for barometer altitude measurements.
* ATT\_EXT\_HDG\_M: Set to 2

It is also a good idea to properly trim the RC values so that the vehicle can hover without too much drift.

* RC Channel 3: Throttle
* RC Channel 4: Yaw \[Increase RC4\_TRIM to Yaw left\]
* RC Channel 1: Roll \[Increase RC1\_TRIM to Roll left\]
* RC Channel 2: Pitch \[Increase RC2\_TRIM to pitch forward\]

For Motive Tracker setup, ensure that the yaw is pointing in the right direction!! It is very important. Otherwise, you'll notice a lot of drifting behavior.

For details on working with GPS Coordinates, see [here](http://www.movable-type.co.uk/scripts/latlong.html).

# **Live Drone Testing from the GCS**

The following steps are required in order to initialize the drone, gcs, motion capture software, and mavros.

1. Make sure that the Jestson, motion capture, and the GCS are all on the same wireless network. In the case of SERL developers this will probably be "SERL GCS 5Ghz."
   1. If a computer is not connected to the correct internet, it may be necessary to restart before proceeding.
2. Setup the Motion capture server
   1. Make sure all the cameras are plugged in via usb to a hub. If there is mor ethan one hub, make sure they are sinked with each other by connecting a wire to the "Input" of one and the "Output" of the other. Then make sure the computer is connected to the cameras with an "A to B USB Cable."
   2. Open the motive software and go to View -&gt; Camera Calibration. Proceed to then wave the wand to calibrate the cameras and set the ground plane.
   3. Once calibration is completed, go to View -&gt; Datastreaming
      1. Check "broadcast frame data"
      2. Double click on the local interface to double check that it has the correct ip address.
   4. Define the rigid body by moving the vehicle into the cameras view and highlighing the illuminated points. Right click, create a rigid body, and go to properties in order to rename the vehicle "quad2"
3. Setup the GCS and Jetson
   1. type "ntpq -c lpeer" into the terminal and check to make sure there is a \* next to the IP address. This means the GCS is synced properly with the system.
   2. run ./mocap\_namespace
   3. in a separate terminal, run ./throttle\_namespace
   4. Now the mocap data will be streaming to the GCS at a manageable 25Hz.
   5. Open a third terminal and SSH into the Jetson so we can call the bootup sequence. ./ssh\_jetson
   6. check the date using the command "date" and make sure it is the same. If not, restart.

   7. at this point, make sure the controller for the drone is turned on a ready to assume manual control of the drone if a complication arises during the flight. This way nobody is injured and the drone is not destroyed in a crash.

   8. run ./launch\_mavros_\__namespace in order to begin the flight sequence.

   9. run the following commands in a new terminal to display the position and orientation of the drone from the mocap system and the drones internal sensors:

      1. rostopic echo V2000/mavros/mocap/pose

      2. rostopic echo V2000/mavros/local\_position/pose

   10. Now that the system is properly displaying data and is sharing data, the flight node can be run: 

       1. rosrun vehicle uav\_control\_test\_node

   11. After a few seconds, the drone should begin its preplanned flight procedures.







