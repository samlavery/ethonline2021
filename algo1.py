#!/usr/bin/python3

import binascii
import math

#This script takes an ethereum address and turns it into 6 different coordinates in fractal space and
#outputs a file in XaoS language to animate it.


#convert 7 bits of binary into an int
def from7bit(data):
    result = 0
    for index, char in enumerate(data):
        byte_value = ord(char)
        result |= (byte_value & 0x7f) << (7 * index)
        if byte_value & 0x80 == 0:
            break
    return result

#Ethermax scam token contract address, for fun
a = "15874d65e649880c2614e7a480cb7c9a55787ff6"
bin = binascii.unhexlify(a)
barray = bytearray(bin)

print(a)
x = float(0)
y = float(0)
newx = float()
newy = float()
for i in range(6):
	t=""
	a = barray.pop(0)
	b = barray.pop(0)
	c = barray.pop(0)
	t += "{0:08b}".format(a)
	t += "{0:08b}".format(b)
	t += "{0:08b}".format(c)
	xstr = t[0:7]
	ystr = t[8:14]
	zstr = t[15:24]
	print("\n\n")	
	x += math.cos(int(xstr,2))/10**i
	y += math.sin(int(ystr,2))/10**i
	print ("(zoomcenter " + str(x)  + " " + str(y) + ")" )
	print ("(usleep " + str(int(zstr,2)*1000) + ")" )




