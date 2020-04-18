#! /usr/bin/env python3

import gpiozero
from time import sleep
from pprint import pprint

STATE_FILE = "/run/chickendoor.state"
VALID_STATES = ('UNKNOWN','OPEN','CLOSED','OPENING','CLOSING')
OK_STATES = [ X for X in VALID_STATES if X != 'UNKNOWN']

state_flag = 'UNKNOWN'

pprint(VALID_STATES)
pprint(OK_STATES)

def initialize (state_flag):
    try:
        handle = open(STATE_FILE)
        state_flag = handle.read().rstrip()
    except IOError:
        print(f"No state file {STATE_FILE}")
    
    if state_flag not in VALID_STATES:
        state_flag = 'UNKNOWN'
    
def door_open ():
    print("Opening")

def door_close ():
    print("Closing")

def door_stop ():
    print("Stop!")
  
initialize(state_flag)

print(f"State is {state_flag}")

while (True) :
    if state_flag not in OK_STATES:
        door_open()
        state_flag = 'OPENING'
    sleep(0.1)
        
