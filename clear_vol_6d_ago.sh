#!/bin/bash

########clear volume#######

data_dir=/var/lib/kubelet/plugins/kubernetes.io/flexvolume/bonuscloud.io/lvm/mounts/

cd $data_dir

count=$(find $data_dir -mtime +6 -name "*.bdf" | wc -l)

echo "------clean date file:$(date +%Y%m%d_%H%M%S)------" >> /tmp/clear.log

if [ "$count" -gt 0 ];then

    find $data_dir -mtime +6 -name "*.bdf" -exec rm -rf {} \;
    echo "------restart container app------"  >> /tmp/container.log
    docker rm -f  $(docker ps | grep -i happ| awk '{print $1}' | xargs )
else
    echo "not found data file 6 days ago"
fi