#!/usr/bin/sh
pause 

echo ### Downloading files
echo ### ...

echo ### installing promisc.service
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


echo -e "### Create Summary file collection.txt ...\n###\n###\n"
echo -e "### Summary" >> collection.txt
echo -e "### Adding blkid to collection.txt\n"
echo -e "### BLKID\n" >> collection.txt
blkid /dev/sda >> collection.txt
echo -e "###\n###\n" >> collection.txt
echo -e "### IDS Gateway\n"
curl ifconfig.me >> collection.txt
echo -e "\n###\n###\n" >> collection.txt
echo -e "###\n###\n"

echo -e "### Generating rsa.pub\n###\n"
echo -e "### rsa.pub\n###\n" >> collection.txt
cat /home/zeek/.ssh/id_rsa.pub >> collection.txt
echo -e "\n###\n###" > collection.txt


echo ### Fetching rsync.sh
wget https://raw.githubusercontent.com/ps1b/canids/main/scripts/rsync.sh
chmod +x rsync.sh

# Fix permissions for zeek user
chown -R zeek:zeek /home/zeek

echo 


echo ### Done
Done
