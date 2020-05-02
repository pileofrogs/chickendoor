# chickendoor

We have chickens and live near Seattle where dawn is very early in the summers.
A system that opens the door to the chicken coop automatically means we can sleep in.  If it can also close the door, it makes vacations easier for a pet sitter.  

## Requirements

* Must fail safe:  IE if it breaks down, we can still open the door and latch it at night. - This is acheived by having the actuator outside of the chicken house and attached with simple pins that a person can pull out without tools
* Must be racoon proof:  Or you might as well not have a door
* Must not crush chickens:  This probably rarely happens, but I would feel aweful if it did.  I added a pressure sensor to make the door open if it hits anything.  
* Open and close based on sunrise & sunset:  No manual adjustmenst over the year.

## Files 

* openscad files for project box, pressure sensor & bracket
* openscad files for helpful objects (screw hole sizer, rpi mount position test)
* python code for running on Rpi

Requires a linear actuator, a set of 2 12v relays, a 12 & 5 v power supply, 
2 buttons && whatever I'm not remembering.

## How it works

The actuator is anchored on the wall outside of the door and to the door, so
when it retracts, it opens the door.  The pressure sensor is basically a hinge
connecting the actuator to the door with a button inside it.  When the actuator
presses on the hinge, it applies pressure to the button.  I just need to
position the button and possibly apply opposing elasic force.  

## TODO

* retry closing if we hit a chicken
* poweroff with long press
* log to syslog/journal
* send alerts if it hits a chicken or has other problems

## For version III

* config file for time offsets
* make brackets adjustable
* make it a service that I can interact with using a client
* make separate monitoring system that can send alerts if the chicken door opener dies
* figure out math for positioning the actuator
* separate latching mechanism
* camera and imge processing to count chickens
* anit-hawk rail-gun with tracking and flight prediction

## Lessons Leaned

* The slop between the pins and the holes they go through really matters.  Shutting the door firmly wihtout setting off the pressure sensor depends on minimal slop.  I was able to offset this by cramming some wire into the holes and screwing wood to the door, making it thicker.  
* setting one of the brackes a few inches off of the wall would really help.  As it is, the closed door is a straight line between them so there's very little leverage keeping it closed and that means any slop translates into a lot of wiggle in the door.
* gpiozero is amazing.  I could have written much simpler code if I'd known how   it works before I got started.

# pins I used

* LEDs 4,17 
* Relays 27,22
* Buttons 23,24

