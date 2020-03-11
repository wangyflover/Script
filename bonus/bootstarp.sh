#!/bin/bash

mkdir -p /opt/bcloud/scripts
cp /happrestart.sh /opt/bcloud/scripts/happrestart.sh
cp /iptablerestart.sh /opt/bcloud/scripts/iptablerestart.sh
chmod +x  /opt/bcloud/scripts/happrestart.sh
chmod +x /opt/bcloud/scripts/iptablerestart.sh

if [ -z "$SINCE" ];then
    SINCE="12:00:00"
fi

if [ -z "$UNTIL" ];then
    UNTIL="17:00:00"
fi
if [ -z "$SIN" ];then
    SIN="01:00:00"
fi
if [ -z "$UNT" ];then
    UNT="17:00:00"

d=`date +%F`
next_since=`date -d "$d $SINCE" +%s`
next_until=`date -d "$d $UNTIL" +%s`
next_sin=`date -d "$d $SIN" +%s`
next_unt=`date -d "$d $UNT" +%s`
while true
do
    now=`date +%s`
    if [ $now -gt $next_sin ] && [ $now -lt $next_unt ];then
        echo `date "+%Y-%m-%d %H:%M:%S"`
        nsenter --mount=/rootfs/proc/1/ns/mnt -- sh -c "/opt/bcloud/scripts/iptablerestart.sh"
        d=`date -d "1 day" +%F`
        next_sin=`date -d "$d $SIN" +%s`
        next_unt=`date -d "$d $UNT" +%s`
#    elif [ $now -gt $next_unt ]; then
#        d=`date -d "1 day" +%F`
#        next_sin=`date -d "$d $SIN" +%s`
#        next_unt=`date -d "$d $SIN" +%s`
    else
        sleep 3600
    fi
    if [ $now -gt $next_since ] && [ $now -lt $next_until ];then
        range=$(($next_until - $now))
        sleep $(($RANDOM % $range))
        echo `date "+%Y-%m-%d %H:%M:%S"`
        nsenter --mount=/rootfs/proc/1/ns/mnt -- sh -c "/opt/bcloud/scripts/happrestart.sh"
        d=`date -d "1 day" +%F`
        next_since=`date -d "$d $SINCE" +%s`
        next_until=`date -d "$d $UNTIL" +%s`
    elif [ $now -gt $next_until ];then
        d=`date -d "1 day" +%F`
        next_since=`date -d "$d $SINCE" +%s`
        next_until=`date -d "$d $UNTIL" +%s`
        sleep 300
    else
        sleep 300
    fi
done
