#!/bin/bash
HOST=$(hostname)
ZABBIX=pvzabbix01.cosmote.gr
KEY=connections_per_hour
LOG_FILE_WITH_CONNECTIONS_PER_HOUR=/lfrote/scripts/log
 
cat /dev/null > $LOG_FILE_WITH_CONNECTIONS_PER_HOUR
TOMCAT_LOG=/lfrote/liferay-otegr/tomcat-7.0.25/logs/localhost_access_log.$(date -d yesterday "+%Y-%m-%d").txt

##epoch time of previous day
##for i in {00..23};do date "+%s" -d "`echo $(date -d yesterday "+%m/%d/%Y $i:00:00")`";done

##with this for loop for 0.00 to 23.00 take per hour connection in format <hostname> <key> <timestamp epoch time> <value>
for i in $(seq -w 0 23);do echo $HOST $KEY $(date "+%s" -d "`echo $(date -d yesterday "+%m/%d/%Y $i:00:00")`")  $(grep "$(date -d yesterday "+%d/%b/%Y"):$i:" $TOMCAT_LOG|wc -l);done >> $LOG_FILE_WITH_CONNECTIONS_PER_HOUR


/usr/bin/zabbix_sender -vv -z $ZABBIX -s $HOST --with-timestamps --input-file $LOG_FILE_WITH_CONNECTIONS_PER_HOUR
