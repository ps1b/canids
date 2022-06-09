# Every 5 minutes
*/5 * * * * /opt/zeek/bin/zeekctl cron

# Every two hours (requries intel-feeds plugin)
# 0 */2 * * * sh /home/zeek/zeek_update_intel-feeds.sh >/dev/null 2>&1

#Sync Zeek logs every hour.
0 * * * * /usr/bin/sh /home/zeek/rsync.sh
