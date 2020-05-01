#! /usr/bin/python3

import gpiozero
from time import sleep

led1 = gpiozero.LED(4)
led2 = gpiozero.LED(17)

relay1 = gpiozero.OutputDevice(22)
relay2 = gpiozero.OutputDevice(27)


while True:
    led1.on()
    led2.off()
    relay1.on()
    relay2.off()
    print(1)
    sleep(10)
    led1.off()
    led2.on()
    relay1.off()
    relay2.on()
    print(2)
    sleep(10)
