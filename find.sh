#!/bin/bash
#
#find <1M file and delete
date=`date +%Y-%m-%d-%H:%M`
log=`cd /var/log/`
file=`find . -type f -size +1M -exec ls -l {} \;`  
for size in $file ; do
	echo "backup file and delete $size"
	cp -a $size $date_$size.bak
done
