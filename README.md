# chickendoor
Files for my automatic chicken door opener

* openscad files for project box, pressure sensor & anything else
* python code for running on Rpi

Requires a linear actuator, a set of 2 12v relays, a 12 & 5 v power supply, 2 buttons && whatever I'm not remembering.

The actuator is anchored on the wall outside of the door and to the door, so when it
retracts, it opens the door.  The pressure sensor is basically a hinge connecting the actuator to the door with a button inside it.  When the actuator presses on the hinge, it applies pressure to the button.  I just need to position the button and possibly apply opposing elasic force.  

## TODO

* retry closing if we hit a chicken
* poweroff
* start on boot
* config file for offsets
* log to syslog

  
# pins

LEDs 4,17 
Relays 27,22
Buttons 23,24

* * 

