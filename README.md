# chickendoor
Files for my automatic chicken door opener

* openscad files for project box, pressure sensor & anything else
* python code for running on Rpi

Requires a linear actuator, a set of 2 12v relays, a 12 & 5 v power supply, 2 buttons && whatever I'm not remembering.

The actuator is anchored on the wall outside of the door and to the door, so when it
retracts, it opens the door.  The pressure sensor is basically a hinge connecting the actuator to the door with a button inside it.  When the actuator presses on the hinge, it applies pressure to the button.  I just need to position the button and possibly apply opposing elasic force.  

## TODO

* pressure sensor
  * hole for button wire (D'oh!)
  * make button waterproof
  * play with sensitivity

* main box
  * transistora anchored and insulated
  * thing for lid to plug into

* lid
  * ~~leds installation & waterproofing~~
  * button
    * ~~connect to grnd of leds~~
    * ~~extra lead to connector thingy~~
    * when I get buttons in mail
      * drill hole for button
      * wire up button
      * install button
  * ~~thing to base to plug into~~

* code
  * everything to do with gpio
    * play with mock pins
    * LEDs
    * button w pull-up 
    * pressure sensor button w pull-up
  
# pins

LEDs 4,17 
Relays 27,22
Buttons 23,24

* * 

