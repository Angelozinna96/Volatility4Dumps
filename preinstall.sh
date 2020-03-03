BASE_DIR="/root/"


#!/bin/bash
yum -y update 
yum -y install kernel-devel  
yum -y install kernel-headers
yum -y install git
yum -y groupinstall 'Development Tools'
yum -y install python27
yum -y install python2-pip
yum -y install python3-pip
yum -y install  libdwarf-tools
yum -y install elfutils-libelf-devel
yum -y install pcre-devel
yum -y install python-devel.x86_64
yum -y install epel-release
yum -y update epel-release

#plugin volatility depedencies 
pip2 install distorm3
pip2 install pycrypto

#full yara installation
cd $BASE_DIR
git clone https://github.com/VirusTotal/yara.git
sudo yum -y install pkgconfig
sudo yum -y install flex bison
sudo yum -y install jansson-devel
sudo yum -y install file-devel #pip3 install python-magic
sudo yum -y install openssl-devel
cd $BASE_DIR/yara/
./bootstrap.sh
./configure --enable-cuckoo --enable-magic
make
sudo make install
make check
#yara-python
cd $BASE_DIR
git clone --recursive https://github.com/VirusTotal/yara-python
cd $BASE_DIR/yara-python
python setup.py build
python setup.py install
cd $BASE_DIR

#volatility installation
git clone https://github.com/volatilityfoundation/volatility.git
cd $BASE_DIR/volatility/
python2 setup.py build
python2 setup.py install

#lime installation 
cd $BASE_DIR
git clone https://github.com/504ensicsLabs/LiME
cd LiME/src/
make
#make a memory dump
name_dump="dump1"
mkdir $BASE_DIR/dumps
lime_ker_version=$(ls |grep lime- -m 1)

insmod $lime_ker_version "path=$Dump_Path/$name_dump.mem format=lime"
#create a profile 
profile_name="centos8"
cd $BASE_DIR
cd volatility/tools/linux
make
head module.dwarf
cd $BASE_DIR
ker_vers=$(uname -r )
zip volatility/volatility/plugins/overlays/linux/$profile_name.zip volatility/tools/linux/module.dwarf /boot/System.map-$ker_vers

python vol.py --info | grep Linux


#plugins volatility
cd $BASE_DIR
git clone https://github.com/superponible/volatility-plugins
git clone https://github.com/mbrown1413/SqliteFind

#optional


#install gnome
#yum -y groupinstall "GNOME Desktop" "Graphical Administration Tools"
#ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target

#install cinnamon 
#yum -y groupinstall "Server with GUI" -y
#yum -y install cinnamon -y
#systemctl set-default graphical.target

#install chrome
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
#sudo yum -y localinstall google-chrome-stable_current_x86_64.rpm
#google-chrome &



#allow remote lime aquisition 
#sudo yum –y install openssh-server openssh-clients
#cosa istallare nella macchina remota 
#yum -y install kernel-devel  
#yum -y install kernel-headers
#yum -y groupinstall 'Development Tools'
#cd /tmp/
#git clone https://github.com/504ensicsLabs/LiME
#cd LiME/src/
#make


