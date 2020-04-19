#! /usr/bin/env python3

import random
import gpiozero
from time import sleep
from pprint import pprint
import datetime
import argparse
now = datetime.datetime.now

TRANSITION_TIME = datetime.timedelta(seconds=10) 
STATE_FILE = "/run/chickendoor.state"
VALID_STATES = ('UNKNOWN','OPEN','CLOSED','OPENING','CLOSING','STOPPED')
OK_STATES = [ X for X in VALID_STATES if X != 'UNKNOWN']
TRANSITORY_STATES = ['OPENING','CLOSING']

state_flag = 'UNKNOWN'

pprint(VALID_STATES)
pprint(OK_STATES)

class Door (object):
    statefile = None
    state = 'UNKNOWN'
    prior_state = None
    started_change_at = datetime.datetime.min
    stopped_of = { 'CLOSING': 'CLOSED', 'OPENING' : 'OPENED' }
    reverse_of = { 'CLOSING': self.open, 'CLOSED': self.open, 
            'OPENING':self.close, 'OPENED': self.close }

    def __init__ (self, state_file = None ):
        if state_file is None:
            state_file = STATE_FILE
        self.statefile = state_file
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
        if now - self.started_change_at > TRANSITION_TIME:
        if not self.is_transetory:
            return None
        self.stop()
        self.set_state(self.stopped_of(self.state))

    def reverse(self):
        self.reverse_of(self.state)()

    def is_transitory(self):
        if self.state in TRANSETORY_STATES:
            return True
        return False

    def set_state(self, new_state):
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
        print("Stop!")`
        self.set_state('STOPPED')

    def update_state_file (self):
        with open(self.statefile,'w') as handle:
            handle.write(self.state)
            handle.close()


def is_button_pressed ():
    if random() > 0.8:
        return true
    return false



parser = argparse.ArgumentParser(description='Chicken Door!')
parser.add_argument('--state_file','-s',default=STATE_FILE, type=str)

args = parser.parse_args()
  
door = Door(args.state_file)

print(f"State is {state_flag}")

while (True) :
    door.check_state()
    if door.is_transetory():
        print('*')
        door.stop_if_time()
    if is_button_pressed():
        if door.is_transetory():
            door.stop()
            sleep(1)
        door.reverse()
            




    sleep(0.5)
        
