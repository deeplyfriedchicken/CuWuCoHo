import serial
import sys
import time

port = "/dev/tty.usbmodem1411"

s = serial.Serial(port, 9600, timeout=5)

data = s.readline()
print data
print type(data)
max_num = float(0)


f = open('emg.txt', 'wb')
while data != "":
    if data > max_num:
        max_num = data
        f.write("MAX: " + str(max_num))
    sys.stdout.write(data)
    sys.stdout.flush()
    f.write(data)
    data = s.readline()
f.close
