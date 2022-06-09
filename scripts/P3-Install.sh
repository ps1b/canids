#!/usr/bin/sh

echo -e "Enabling Powertools"
sed -i -e "s|enabled=0|enabled=1|g" /etc/yum.repos.d/CentOS-Stream-PowerTools.repo

echo -e "### Creating zeek user and group"
groupadd zeek && useradd zeek -g zeek
echo -e "### Creating create /opt/zeek and assign permissions"
mkdir /opt/zeek /home/zeek/.ssh
chown -R zeek:zeek /opt/zeek/ /home/zeek
echo -e "### Creating RSA key pair"
ssh-keygen -q -t rsa -b 4096 -N '' -f /home/zeek/.ssh/id_rsa <<<y >/dev/null 2>&1

echo -e "### Fixing permissions for zeek user..."
chown -R zeek:zeek /opt/zeek/ /home/zeek

echo -e "### Downloading and installing files...\n###"
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
chown -R zeek:zeek /opt/zeek/ /home/zeek

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
