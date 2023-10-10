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
 --bench-ids iperf:21-26,uperf:1-20,uperf:27-32\
 --tags $tags \
 --num-samples=$num_samples --max-sample-failures=2\
 --endpoint k8s,user:kni,host:$ocp_host,\
nodeSelector:client-1-7+21-22+27:$SCRIPT_DIR/nodeSelector-worker0.json,\
nodeSelector:client-8-14+30:$SCRIPT_DIR/nodeSelector-worker1.json,\
nodeSelector:client-15-20+23-26+28-29+31-32:$SCRIPT_DIR/nodeSelector-worker2.json,\
nodeSelector:server-1-22+25-27+31-32:$SCRIPT_DIR/nodeSelector-worker2.json,\
nodeSelector:server-28:$SCRIPT_DIR/nodeSelector-worker0.json,\
nodeSelector:server-23-24+29:$SCRIPT_DIR/nodeSelector-worker1.json,\
userenv:stream8,\
resources:default:$SCRIPT_DIR/resource-2req.json,\
resources:client-1-20:$SCRIPT_DIR/resource-1req.json,\
controller-ip:192.168.5.30,\
client:1-32,\
server:1-32
