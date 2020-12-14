#!/usr/bin/env python

# generate the simple lemmas equating pow-evocations to constants

for i in range(9,32):
    print "lemma pow2_%(x)d: pow2 %(x)d = 0x%(y)x" % { 'x': 8*i, 'y': 2**(8*i) }
