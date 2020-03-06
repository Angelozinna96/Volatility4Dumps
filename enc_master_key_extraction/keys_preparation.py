#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar  4 12:51:14 2020

@author: angelozinna
"""
import sys
#assumption = 512 aes keys are made by 2 different 256 aes key, 256 keys are made by 2 different 128 aes keys, and so on...
filename = sys.argv[1]
path_save="./"
final_filename="possible_keys"
FINAL_KEY_SIZE=512
half_key_size=FINAL_KEY_SIZE/2
half_hex_key_size = half_key_size / 4 
half_keys=[]
possible_keys=[]
f=open(filename,'r')
while True:
    line = f.readline()
    if not line:
        break
    
    if(len(line[0:-1]) == half_hex_key_size ):
        half_keys.append(line[0:-1])
#print (half_keys)

for first in half_keys:
    for last in half_keys:
        if (first != last):
            possible_keys.append(first+last)
possible_keys=list(set(possible_keys))
if( not len(possible_keys)):
    print("Noone key found!")
    sys.exit()
#print (possible_keys)
#print (len(possible_keys))
f.close()
wr= open(path_save+final_filename,'w')
for el in possible_keys:
    wr.writelines(el+'\n')
wr.close()
    


