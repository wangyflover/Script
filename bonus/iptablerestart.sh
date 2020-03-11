#!/bin/sh
init=`docker ps -a 2>/dev/null | grep init | awk '{print $1}' |xargs`
if [ -n "$init" ];then
	docker restart $init
else
	echo "no init container exist" 
	docker rmi -f a3b7cfa37ed8
fi
exit 0