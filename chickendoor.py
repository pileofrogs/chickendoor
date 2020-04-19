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
        return self.state;

    def set_state(self, new_state):
        self.state = new_state
        self.update_state_file(
        
    def open (self):
        print("Opening")
        self.set_state('OPENING')
    
    def close (self):
        print("Closing")
        self.set_state('OPENING')
    
    def stop (self):
        print("Stop!")
        self.set_state('STOPPED')

    def 
    
    def write_state_file (self):
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
  
state_flag = initialize(args.state_file)

print(f"State is {state_flag}")

started_change_at = datetime.datetime.min
while (True) :
    if state_flag not in OK_STATES:
        door_open()
        state_flag = 'OPENING'
        write_state_file(args.state_file,state_flag)
        started_change_at = now()
    if state_flag in TRANSITORY_STATES:
        print('*')
        if now() - started_change_at > TRANSITION_TIME:
            door_stop()
            if state_flag == 'OPENING':
                state_flag = 'OPEN'
                write_state_file(args.state_file,state_flag)
            elif state_flag == 'CLOSING':
                state_flag = 'CLOSED'
                write_state_file(args.state_file,state_flag)
    if is_button_pressed():
        if state_flag in TRANSITORY_STATES:
            door_stop()
            sleep(1)
            if state_flag == 'OPENING':
                door_close()
                state_flag = 'CLOSING'
                write_state_file(args.state_file, state_flag)
            elif state_flag == 'CLOSING':
                door_open()
                state_flag = 'OPENING'
                write_state_file(args.state_file, state_flag)
        else:
            




    sleep(0.5)
        
