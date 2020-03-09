#!/bin/sh
CURR_FOLDER="./"
MEMORY_DUMP="$1"
DIR="aeskeyfind"
if [ "$1" == "" ] || [ $# -gt 1 ]; then
        echo "Insert a memory dump!"
        exit 0
fi

if [ ! -d  "$DIR" ]; then 
	wget -P $CURR_FOLDER "https://citpsite.s3.amazonaws.com/memory-content/src/aeskeyfind-1.0.tar.gz"
	for file in *.tar.gz; do tar xzvf "${file}" && rm "${file}"; done

	cd aeskeyfind/
	make
	cd ..
fi

cp $DIR"/aeskeyfind" aes_key_find
./aeskeyfind $MEMORY_DUMP > ./key_files

python3 ./keys_preparation.py key_files
