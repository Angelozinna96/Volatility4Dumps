#!/bin/sh
PART="/dev/sda2"
while read -r line; do

	$( printf $line | xxd -r -ps > key_file)
	sudo cryptsetup luksOpen --master-key-file key_file --test-passphrase "$PART" && echo "Found=$line"
	rm -f key_file
done < possible_keys
printf "" | xxd -r -ps > key_file
