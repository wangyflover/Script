#!/bin/bash
#
#find <1G file and delete
file=`find / -type f -size +100M `  
echo "The $file then 100M big"
