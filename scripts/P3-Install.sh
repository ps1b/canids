#!/usr/bin/sh
pause 

echo Downloading files
echo ...

echo #installing promisc.service
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/promisc.service
chmod u+x promisc.service
mv promisc.service /etc/systemd/system/
systemctl enable promisc.service
systemctl start promisc.service

echo ### installing zeek.service
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/zeek.service
chmod u+x zeek.service
mv zeek.service /etc/systemd/system/
systemctl enable zeek.service

echo ### Fetching rsync.sh
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/rsync.sh
chmod +x rsync.sh

echo ### Creating RSA key pair
ssh-keygen -q -t rsa -b 4096 -N '' -f /home/zeek/.ssh/id_rsa <<<y >/dev/null 2>&1

# Fix permissions for zeek user
chown -R zeek:zeek /home/zeek


echo ###
echo ### Create Summary file 'collection.txt'...
echo ###
echo ### IDS Gateway:
curl ifconfig.me >> collection.txt
echo ### rsa.pub >> collection.txt
cat /home/zeek/.ssh/id_rsa.pub >> collection.txt
echo ###


echo ### Fetching rsync.sh
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/rsync.sh
chmod +x rsync.sh

# Fix permissions for zeek user
chown -R zeek:zeek /home/zeek

echo 


echo ### Done
Done
