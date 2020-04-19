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

# alias now() to datetime.datetime.now()
now = datetime.datetime.now

AM_OFFSET = datetime.timedelta(minutes=10)
PM_OFFSET = datetime.timedelta(minutes=-10)
TRANSITION_TIME = datetime.timedelta(seconds=2) 
STATE_FILE = "/run/chickendoor.state"
VALID_STATES = ('UNKNOWN','OPEN','CLOSED','OPENING','CLOSING','STOPPED')
OK_STATES = [ X for X in VALID_STATES if X not in ('UNKNOWN','STOPPED') ]
TRANSITORY_STATES = ['OPENING','CLOSING']

# where we is
here = lookup('Seattle',database())

class Door (object):
    statefile = None
    state = 'UNKNOWN'
    prior_state = None
    started_change_at = datetime.datetime.min
    stopped_of = { 'CLOSING': 'CLOSED', 'OPENING' : 'OPEN' }
    reverse_of = None
    been = { 'timer': { 'opened' : None, 'closed' None }, 'button': { 'opened':None, 'closed': None }}

    def __init__ (self, state_file = None ):
        if state_file is None:
            state_file = STATE_FILE
        self.statefile = state_file
        self.reverse_of = { 'CLOSING': self.open, 'CLOSED': self.open, 
            'OPENING':self.close, 'OPEN': self.close }
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
        self.state = new_state
        self.update_state_file()
        self.started_change_at = now()
        
    def open (self):
        print("Opening")
        self.set_state('OPENING')
    
    def close (self):
        print("Closing")
        self.set_state('CLOSING')
    
    def stop (self):
        print("Stop!")
        self.set_state('STOPPED')

    def update_state_file (self):
        with open(self.statefile,'w') as handle:
            handle.write(self.state)
            handle.close()


def is_button_pressed ():
    if random() > 0.8:
        print("********** BUTTON ************")
        return True
    return False



parser = argparse.ArgumentParser(description='Chicken Door!')
parser.add_argument('--state_file','-s',default=STATE_FILE, type=str)

args = parser.parse_args()
  
door = Door(args.state_file)
mytz = pytz.timezone(here.timezone)

# I need to track openings or somehow keep it from automatically opening all day and closing all night

while (True) :
    door.check_state()
    suntime = sun(here.observer, date=now(), tzinfo=mytz)
    if now(mytz) > suntime["sunrise"] and now(mytz) <= suntime["sunset"]:
        print("It's Daytime!")
    else :
        print("It's Night!")
    
    print(f"Ma State Be {door.state}")
    if door.is_transitory():
        print('*')
        door.stop_if_time()
    if is_button_pressed():
        if door.is_transitory():
            door.stop()
            sleep(1)
        door.reverse()
    sleep(0.5)
        
