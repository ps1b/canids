#!/usr/bin/sh

# Install script for P3 zeek hardware.

echo -e "Enabling Powertools"
sed -i -e "s|enabled=0|enabled=1|g" /etc/yum.repos.d/CentOS-Stream-PowerTools.repo

echo -e "Install zeek repository"
cd /etc/yum.repos.d/ && wget https://download.opensuse.org/repositories/security:zeek/CentOS_8_Stream/security:zeek.repo

echo -e "Install Dependencies and zeek"
yum -y install cmake make gcc gcc-c++ flex bison libpcap-devel openssl-devel platform-python-devel swig zlib-devel kernel-devel kernel-headers python36 network-scripts tar wget gdb git python3-pip sendmail sendmail-cf rsync unzip epel-release tcpdump zeek-lts zeek-lts-devel

echo -e "### Creating zeek user and group"
groupadd zeek && useradd zeek -g zeek

echo -e "### Creating create /opt/zeek/, /home/zeek/.ssh, /home/zeek/zeek-install"
mkdir /opt/zeek /home/zeek/.ssh /home/zeek/zeek-install

echo -e "### Creating RSA key pair"
ssh-keygen -q -t rsa -b 4096 -N '' -f /home/zeek/.ssh/id_rsa <<<y >/dev/null 2>&1

echo -e "### Fixing permissions for zeek user..."
chown -R zeek:zeek /opt/zeek/ /home/zeek && setcap cap_net_raw=eip /opt/zeek/bin/zeek && setcap cap_net_raw=eip /opt/zeek/bin/capstats

echo -e "### Downloading and installing files into /home/zeek/install\n###"
cd /home/zeek/zeek-install
echo -e "### installing promisc.service"
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/promisc.service
chmod u+x promisc.service
mv promisc.service /etc/systemd/system/
systemctl enable promisc.service
systemctl start promisc.service

echo -e "### installing zeek.service"
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/zeek.service
chmod u+x zeek.service
mv zeek.service /etc/systemd/system/
systemctl enable zeek.service

echo -e "### Downloading crontabs"
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/crontab.zeek
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/crontab.root
mv crontab.zeek crontab.root /home/zeek

echo -e "### Fetching rsync.sh"
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/rsync.sh
chmod +x rsync.sh
mv rsync.sh /home/zeek

echo -e "### Fixing permissions for zeek user..."
chown -R zeek:zeek /opt/zeek/ /home/zeek && setcap cap_net_raw=eip /opt/zeek/bin/zeek && setcap cap_net_raw=eip /opt/zeek/bin/capstats


echo -e "### Create Summary file collection.txt ...\n###"
echo -e "### Summary" > collection.txt
echo -e "### Adding blkid to collection.txt\n"
echo -e "### BLKID /dev/sda:" >> collection.txt
blkid /dev/sda >> collection.txt
echo -e "###" >> collection.txt
echo -e "### Writing IDS Gateway..."
echo -e "### Gateway" >> collection.txt
curl ifconfig.me >> collection.txt
echo -e "\n###" >> collection.txt
echo -e "###\n###\n"
echo -e "### Log rsa.pub\n###"
echo -e "### rsa.pub\n###" >> collection.txt
cat /home/zeek/.ssh/id_rsa.pub >> collection.txt
echo -e "### To Do:\n### Install crontabs located in /home/zeek/crontab.*" >> collection.txt
echo -e "\n###" >> collection.txt

echo -e "### Done"
Done
