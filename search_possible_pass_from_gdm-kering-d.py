#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 15:37:19 2020

@author: angelozinna
"""
import sys
if (len(sys.argv)<2):
    sys.exit()
filename=sys.argv[1]
with open(filename,"rb") as f:
    zero=0x0
    byte=0x0
    pot_string=[]
    goodstr=[]
    init=0x7f
    readytoread=False
    while (True):
        byte=f.read(1)
        if not byte:
            break
        byte = int(byte.hex(),16)
        
        if(byte == init):
            byte = int(f.read(2).hex(),16)
            if(byte == zero):
                readytoread=True
                continue
        if(readytoread):
            if( byte >=0x20 and byte <=0x7E):
                pot_string.append(chr(byte))
            else:
                if(byte == 0 and len(pot_string)>4):
                    goodstr.append("".join(pot_string))
                readytoread=False
                pot_string=[]
    for st in goodstr:
        if st:
            print (st)


