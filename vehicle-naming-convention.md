# Summary

The identification of a vehicle in the physical world vs one in a computer database is an important distinction. This section will cover the naming conventions for the initialization, organization, and usage of vehicles.

# Organization

Internally, the ground station will assign a vehicle a number within a range in order to keep track of it. The number will be what the computer refers to whenever it needs to give a command to a specific vehicle. Externally, humans should refer to vehicles by both their type and relative number in the computer database, such as "Quad1", "Octo3", "UGV10", or "VTOL2", when speaking to each other to prevent confusion. When interfacing with the NAO robot, the operator should have the option to provide the NAO robot with either the internal or external ID to execute a command.

### Unmanned Ground Vehicle \(UGV\)

Unmanned Ground Vehicles are defined by numbers in the range of 1000 - 1999.

### Quad Rotor

Quad rotors are defined by numbers in the range of 2000 - 2999.

### Octo Rotor

Octo Rotors are defined by numbers in the range of 3000 - 3999.

### Vertical Takeoff and Landing \(VTOL\)

Vertical Takeoff and Landing vehicles are defined by numbers in the range of 4000 - 4999.

# Vehicle Initialization

A vehicle that wishes to be added to the vehicle index will broadcast its machine name with its type, such as "Quad1" or "QuadCharlie" \(note the 1 in Quad does not determine its order in the system database\). The computer will read this signal and add the vehicle to the next position in its type grouping. For example, the 4th Quad will be added to the Quad grouping as number 2004 in the computer database and would be refered to as "Quad4" by operators.

