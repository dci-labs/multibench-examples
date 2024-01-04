#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo $*

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

crucible run iperf,uperf\
 --mv-params iperf-mv-params.json,uperf-mv-params.json\
 --bench-ids iperf:3-4,uperf:1-2,uperf:5-6\
 --tags $tags \
 --num-samples=$num_samples --max-sample-failures=2\
 --endpoint k8s,user:kni,host:$ocp_host,\
nodeSelector:client-1-2:$SCRIPT_DIR/nodeSelector-worker0.json,\
nodeSelector:client-3-4:$SCRIPT_DIR/nodeSelector-worker1.json,\
nodeSelector:client-5-6:$SCRIPT_DIR/nodeSelector-worker2.json,\
nodeSelector:server-1-2:$SCRIPT_DIR/nodeSelector-worker2.json,\
nodeSelector:server-3-4:$SCRIPT_DIR/nodeSelector-worker0.json,\
nodeSelector:server-5-6:$SCRIPT_DIR/nodeSelector-worker1.json,\
userenv:stream8,\
resources:default:$SCRIPT_DIR/resource-2req-daily.json,\
resources:client-1-6:$SCRIPT_DIR/resource-1req-daily.json,\
controller-ip:192.168.5.30,\
client:1-6,\
server:1-6
