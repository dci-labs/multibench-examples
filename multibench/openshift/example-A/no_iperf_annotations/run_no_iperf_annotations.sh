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

crucible run uperf\
 --mv-params uperf2-mv-params.json\
 --bench-ids uperf:1-19\
 --tags $tags \
 --num-samples=$num_samples --max-sample-failures=2\
 --endpoint k8s,user:kni,host:$ocp_host,\
nodeSelector:client-1-7:$SCRIPT_DIR/nodeSelector-worker0.json,\
nodeSelector:client-8-14:$SCRIPT_DIR/nodeSelector-worker1.json,\
nodeSelector:client-15-19:$SCRIPT_DIR/nodeSelector-worker2.json,\
nodeSelector:server-1-19:$SCRIPT_DIR/nodeSelector-worker2.json,\
userenv:stream8,\
resources:default:$SCRIPT_DIR/resource-2req.json,\
resources:client-1-20:$SCRIPT_DIR/resource-1req.json,\
annotations:client-1-32:$SCRIPT_DIR/annotations-client.json,\
annotations:server-1-32:$SCRIPT_DIR/annotations-server.json,\
runtimeClassName:performance-blueprint-profile,\
controller-ip:192.168.5.30,\
client:1-19,\
server:1-19
