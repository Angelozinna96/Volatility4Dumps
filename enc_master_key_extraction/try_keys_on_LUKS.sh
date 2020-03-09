#!/bin/sh
PART="$1"
KEYS_FILE="possible_keys"
if [ "$1" == "" ] || [ $# -gt 1 ]; then
        PART="/dev/sda2"
fi
while read -r line; do

	$( printf $line | xxd -r -ps > key_file)
	sudo cryptsetup luksOpen --master-key-file key_file --test-passphrase "$PART" 2> /dev/null && echo "Found=$line"
	rm -f key_file
done < "$KEYS_FILE"
printf "" | xxd -r -ps > key_file