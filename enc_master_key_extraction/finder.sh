#!/bin/sh
CURR_FOLDER="./"
wget -P $CURR_FOLDER "https://citpsite.s3.amazonaws.com/memory-content/src/aeskeyfind-1.0.tar.gz"
tar -zxvf $CURR_FOLDER"aeskeyfind-1.0.tar.gz"
printf "" | xxd -r -ps > key_file
