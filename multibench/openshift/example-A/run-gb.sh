#!/bin/bash

config=$1
if [ -z "$config" ]; then
    echo "config file not specified.  Use ./run.sh <your-config-file>"
    exit 1
fi
if [ ! -e $config ]; then
    echo "Could not find $config, exiting"
    exit 1
fi
. $config

if [ -z "$tags" ]; then
    echo "You must define tags in your config file"
    exit 1
fi

if [ -z "$ocp_host" ]; then
    echo "You must define ocp_host in your config file"
    exit 1
fi

if [ -z "$num_samples" ]; then
    echo "You must define num_samples in your config file"
    exit 1
fi

pwd=`/bin/pwd`

crucible run uperf\
 --mv-params uperf-mv-params-stream.json\
 --bench-ids uperf:1-6\
 --tags $tags \
 --num-samples=$num_samples --max-sample-failures=2\
 --endpoint k8s,user:kni,host:$ocp_host,\
nodeSelector:client-1-3:$pwd/nodeSelector-worker0.json,\
nodeSelector:client-4-6:$pwd/nodeSelector-worker1.json,\
nodeSelector:server-1-6:$pwd/nodeSelector-worker2.json,\
userenv:stream8,\
resources:default:$pwd/resource-2req.json,\
controller-ip:192.168.5.30,\
client:1-6,\
server:1-6
