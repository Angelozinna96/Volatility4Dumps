# Volatility4Dumps
It contains some little script that can helps who are investigating with Linux memory dumps.

I made three little programs so far, that are:
-Data Browser: extraction of cookies and history data (also the hidden ones) from Chrome (Chrome v79.0.3945.117 64 bit) and Firefox (Firefox Quantum v68.3.0esr 64 bit) using Volatility and its plugins.
-Login password: extraction of login password of the logged user, exploiting the gnome keyring deamon (tested only on v3.28.2) that save it as plain text (heuristic method).
script for password extration from memory dump, 
-Encryption master key extraction: It is dependent of another script from https://citp.princeton.edu/our-work/memory/ that extract AES 128 and 256 keys from a memory dump.My script performs all permutation of AES-256 key two by two in order to generate all possible AES-512 keys (that is the default size of master key in dm-crypt with LUKS on Centos 7) and after that it tries all those keys to decrypt a selected volume. Other informations are available into the README of the folder.

All these scripts have been only tested on centos7 and centos8!!


Togheter with an university peer of mine, I integrated all these scripts into another program called "Limeator"(https://github.com/Lorenzoabb/limeator) that also but not only helps to simplify the installation and use of Volatility and LiME, so in order to easily execute my scripts I suggest you to download Limeator, since that my scripts are used there.