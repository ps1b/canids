rootDir="/opt/zeek/logs/"
for day in 0 1 2 3 4 5 6 7
do
    dirName="${rootDir}"$(date  --date=${day}" days ago" +%Y-%m-%d);
    echo $dirName;

# Upload all zeek logs except those that may contain PII.
rsync -av --progress -e "ssh -p 56320" --exclude={"http.*.log.gz","ftp.*.log.gz","ntlm.*.log.gz","irc.*.log.gz","sip.*.log.gz","radius.*.log.gz","smtp.*.log.gz","rdp.*.log.gz","files.*.log.gz","syslog.*.log.gz","snmp.*.log.gz",stats,current} $dirName username@push.jointsecurity.ca:

done
