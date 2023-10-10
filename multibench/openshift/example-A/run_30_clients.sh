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
 --bench-ids iperf:19-24,uperf:1-18,uperf:25-30\
 --tags $tags \
 --num-samples=$num_samples --max-sample-failures=2\
 --endpoint k8s,user:kni,host:$ocp_host,\
nodeSelector:client-1-6+19-20+25-26:$SCRIPT_DIR/nodeSelector-worker0.json,\
nodeSelector:client-7-12+21-22+27-28:$SCRIPT_DIR/nodeSelector-worker1.json,\
nodeSelector:client-13-18+23-24+29-30:$SCRIPT_DIR/nodeSelector-worker2.json,\
nodeSelector:server-1-2+7-8+13-14+21+23+25+27:$SCRIPT_DIR/nodeSelector-worker2.json,\
nodeSelector:server-3-4+9-10+15-16+19-20+26+29:$SCRIPT_DIR/nodeSelector-worker0.json,\
nodeSelector:server-5-6+11-12+17-18+22+24+28+30:$SCRIPT_DIR/nodeSelector-worker1.json,\
userenv:stream8,\
resources:default:$SCRIPT_DIR/resource-2req.json,\
resources:client-21-26:$SCRIPT_DIR/resource-1req.json,\
controller-ip:192.168.5.30,\
client:1-30,\
server:1-30
