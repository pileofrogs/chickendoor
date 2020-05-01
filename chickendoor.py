#! /usr/bin/env python3

from random import random
import gpiozero
from time import sleep
from pprint import pprint
import datetime
import argparse
from astral.geocoder import database, lookup
from astral.sun import sun
import astral
import pytz
import os


# alias now() to datetime.datetime.now()
now = datetime.datetime.now

# pin numbers
LED_O = 17
LED_C = 4 
RELAY_O = 22
RELAY_C = 27
BUTTON = 23
PRESSURE = 24

TRANSITION_TIME = datetime.timedelta(seconds=10) 
DAY = datetime.timedelta(hours=24)
STATE_FILE = "/run/chickendoor.state"
VALID_STATES = ('UNKNOWN','OPEN','CLOSED','OPENING','CLOSING','STOPPED')
OK_STATES = [ X for X in VALID_STATES if X not in ('UNKNOWN','STOPPED') ]
TRANSITORY_STATES = ['OPENING','CLOSING']
BUTTON_WAIT = datetime.timedelta(seconds=1)

here = lookup('Seattle',database())
mytz = pytz.timezone(here.timezone)
epoch = datetime.datetime.fromtimestamp(0, tz=mytz)

class Door (object):
    device = None
    button = None
    pressure_sensor = None
    open_led = None
    close_led = None
    open_relay = None
    close_relay = None
    statefile = None
    state = 'UNKNOWN'
    prior_state = None
    started_change_at = datetime.datetime.min
    stopped_of = { 'CLOSING': 'CLOSED', 'OPENING' : 'OPEN' }
    opposite_of = { 'CLOSING': 'OPENING', 'CLOSED': 'OPEN', 
            'OPENING':'CLOSING', 'OPEN': 'CLOSED' }
    reverse_of = None

    def __init__ (self, state_file = None ):
        if state_file is None:
            state_file = STATE_FILE
        self.statefile = state_file
        self.reverse_of = { 'CLOSING': self.open, 'CLOSED': self.open, 
            'OPENING':self.close, 'OPEN': self.close }
        
        self.button = gpiozero.Button(BUTTON)
        self.pressure_sensor = gpiozero.Button(PRESSURE)
        self.open_led = gpiozero.LED(LED_O)
        self.close_led = gpiozero.LED(LED_C)
        self.open_relay = gpiozero.OutputDevice(RELAY_O)
        self.close_relay = gpiozero.OutputDevice(RELAY_C)

        self.led_of = {'OPENING': self.open_led, 'OPEN': self.open_led,
                'CLOSING': self.close_led, 'CLOSED': self.close_led }

        self.button.when_pressed = self.press_button
        self.pressure_sensor.when_pressed = self.sense_pressure
        
        try:
            handle = open(self.statefile)
            self.set_state(handle.read().rstrip())
            print(f"*** State File Says {self.state} ***")
            handle.close()
        except IOError:
            print(f"Failed to open state file {self.statefile}")

    def check_state(self):
        if self.state not in OK_STATES:
            self.open()
            return
        self.led_of[self.state].on()
        self.led_of[self.opposite_of[self.state]].off()

    def stop_if_time(self):
        if now() - self.started_change_at < TRANSITION_TIME:
            return None
        if not self.is_transitory:
            return None
        print("--------- TIME ---------")
        self.stop()
        self.set_state(self.stopped_of[self.prior_state])

    def reverse(self):
        state = self.state
        if state == 'STOPPED':
            print(f"I am stopped, but before that I was {self.prior_state}")
            state = self.prior_state
        if state == 'UNKNOWN':
            return None
        print(f"Reverse of {state} is {self.reverse_of[state]}")
        self.reverse_of[state]()

    def is_transitory(self):
        if self.state in TRANSITORY_STATES:
            return True
        return False

    def set_state(self, new_state):
        if self.state != self.prior_state:
            self.prior_state = self.state
        print(new_state)
        self.state = new_state
        self.update_state_file()
        self.started_change_at = now()
        
    def open (self):
        print("Opening")
        self.open_relay.on()
        self.close_relay.off()
        self.open_led.blink()
        self.close_led.off()
        self.set_state('OPENING')
    
    def close (self):
        print("Closing")
        self.open_relay.off()
        self.close_relay.on()
        self.set_state('CLOSING')
        self.close_led.blink()
        self.open_led.off()
    
    def stop (self):
        print("Stop!")
        self.open_relay.off()
        self.close_relay.off()
        if self.state in self.led_of:
            print(self.state)
            self.led_of[self.state].on()
            self.led_of[self.opposite_of[self.state]].off()
        else :
            print("Stopping in state {self.state}")
        self.set_state('STOPPED')

    def update_state_file (self):
        with open(self.statefile,'w') as handle:
            handle.write(self.state)
            handle.close()

    def press_button (self):
        print("Button!")
        self.reverse()

    def sense_pressure (self):
        print("Pressure sensor!")
        if self.state is not "CLOSING":
            print("Not Closing, do nothing")
            return
        self.open()



def minute_of (time: datetime) -> int:
    return int(time.timestamp()/60)

parser = argparse.ArgumentParser(description='Chicken Door!')
parser.add_argument('--state_file','-s',default=STATE_FILE, type=str)
parser.add_argument('--sunup_offset','-u',default=0, type=int)
parser.add_argument('--sundown_offset','-d',default=0, type=int)

#PM_OFFSET = datetime.timedelta(minutes=-10)

args = parser.parse_args()

os.system("/DietPi/dietpi/func/run_ntpd")
  
door = Door(args.state_file)

door.check_state()

last_minute = 0
last_press_at = epoch
while (True) :
    tnow = now(mytz)
    # we don't know when we actually stop,
    # so we just stop after a while
    if door.is_transitory():
        print('transitioning')
        door.stop_if_time()
    # We check time-based stuff every minute
    this_minute = minute_of(tnow)
    if this_minute <= last_minute:
        sleep(0.5)
        continue
    last_minute = this_minute
    suntime = sun(here.observer, date=tnow, tzinfo=mytz)
    open_at = suntime['sunrise']+datetime.timedelta(minutes=args.sunup_offset) 
    open_at_minute = minute_of(open_at)
    close_at = suntime['dusk']+datetime.timedelta(minutes=args.sundown_offset) 
    close_at_minute = minute_of(close_at)

    if close_at_minute < this_minute:
        print("Passed closing, calculating for tomorrow")
        close_at = close_at+DAY
        close_at_minute = minute_of(close_at)
    if open_at_minute < this_minute:
        print("Passed opening, calculating for tomorrow")
        open_at = open_at+DAY
        open_at_minute = minute_of(open_at)

    print(f"close {close_at - tnow} from now")
    print(f"open {open_at - tnow} from now")

    print("")
    print(f"Now is {tnow}")
    print(f"close_at {close_at}")
    print(f"open_at  {open_at}")
    print("")
    print(f"This minute {this_minute}")
    print(f"close_at_minute {close_at_minute}")
    print(f"open_at_minute  {open_at_minute}")


    if this_minute == close_at_minute:
        door.close()
    if this_minute == open_at_minute:
        door.open()

    sleep(0.5)
        
