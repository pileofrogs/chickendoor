#! /usr/bin/env python3

from random import random
import gpiozero
from time import sleep
from pprint import pprint
import datetime
import argparse
now = datetime.datetime.now

TRANSITION_TIME = datetime.timedelta(seconds=2) 
STATE_FILE = "/run/chickendoor.state"
VALID_STATES = ('UNKNOWN','OPEN','CLOSED','OPENING','CLOSING','STOPPED')
OK_STATES = [ X for X in VALID_STATES if X != 'UNKNOWN']
TRANSITORY_STATES = ['OPENING','CLOSING']

pprint(VALID_STATES)
pprint(OK_STATES)

class Door (object):
    statefile = None
    state = 'UNKNOWN'
    prior_state = None
    started_change_at = datetime.datetime.min
    stopped_of = { 'CLOSING': 'CLOSED', 'OPENING' : 'OPEN' }
    reverse_of = None

    def __init__ (self, state_file = None ):
        if state_file is None:
            state_file = STATE_FILE
        self.statefile = state_file
        self.reverse_of = { 'CLOSING': self.open, 'CLOSED': self.open, 
            'OPENING':self.close, 'OPEN': self.close }
        try:
            handle = open(self.statefile)
            self.set_state(handle.read().rstrip())
            print(f"*** {self.state} ***")
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
            state = self.prior_state
        if state == 'UNKNOWN':
            self.open()
            return None
        print(self.reverse_of[state])
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
        self.set_state('OPENING')
    
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

while (True) :
    door.check_state()
    if door.is_transitory():
        print('*')
        door.stop_if_time()
    if is_button_pressed():
        if door.is_transitory():
            door.stop()
            sleep(1)
        door.reverse()
    sleep(0.5)
        
