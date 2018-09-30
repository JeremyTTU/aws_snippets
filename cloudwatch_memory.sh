#!/bin/bash
InstanceID=`curl -s http://169.254.169.254/latest/meta-data/instance-id` 
az=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
region="`echo \"$az\" | sed 's/[a-z]$//'`"
awkscript1='{print "TotalMemory:"$2"|UsedMemory:"$3"|FreeMemory:"$4"|SharedMemory:"$5"|CacheMemory:"$6"|AvailMemory:"$7 }'
memout=`free | grep Mem | awk "$awkscript1"`
lined=${memout//"|"/\\n}
awkscript2='{print "aws cloudwatch put-metric-data --region REGION --namespace MemoryStats --unit Megabytes --metric-name "$1" --value "$2" --dimensions InstanceId=ID" }'
awkscript3=${awkscript2/ID/$InstanceID}
linked=${awkscript3/REGION/$region}
echo -e "$lined" | awk -F":" "$linked"
