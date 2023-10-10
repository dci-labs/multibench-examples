#!/bin/bash

set -xe
# Example of how to use the crucible get metric CMD

SOURCE=$1
TYPE=$2

if [ -z "$SOURCE" ]; then
    echo "A source is nedded! Choose between: procstat mpstat uperf iperf iostat sar-net ..."
    exit 1
fi

if [ -z "$TYPE" ]; then
    echo "Which metric do you want to fetch?"
    exit 1
fi

echo ""
echo "==== Run Without POA ====="
VALUE1=$(crucible get metric --period 547FDFD2-E504-11ED-AD84-2D651A08D89E --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
if [ -z "$VALUE1" ]; then
    echo "[Error] Wrong Source or type: no value found! Check you args."
    exit 1
fi
VALUE2=$(crucible get metric --period 5348CAF2-E504-11ED-8049-2D651A08D89E --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
VALUE3=$(crucible get metric --period 541391F6-E504-11ED-AD84-2D651A08D89E --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
SUM=$(echo $VALUE1 + $VALUE2 + $VALUE3 | bc)
bc <<< "scale=3; $SUM/3"

echo "---"
echo "==== Run With Old POA ===="
VALUE1=$(crucible get metric --period 907A601E-E42F-11ED-9CC2-C15D03A6328A --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
VALUE2=$(crucible get metric --period 917C67E6-E42F-11ED-9856-C15D03A6328A --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
VALUE3=$(crucible get metric --period 91023408-E42F-11ED-9856-C15D03A6328A --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
SUM=$(echo $VALUE1 + $VALUE2 + $VALUE3 | bc)
bc <<< "scale=3; $SUM/3"
echo "---"
echo "==== Run With New POA ===="
VALUE1=$(crucible get metric --period E464A70C-E9B1-11ED-B7C1-143A94DACD0C --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
VALUE2=$(crucible get metric --period E3D525AA-E9B1-11ED-867D-143A94DACD0C --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
VALUE3=$(crucible get metric --period E4F93E6C-E9B1-11ED-B7C1-143A94DACD0C --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
SUM=$(echo $VALUE1 + $VALUE2 + $VALUE3 | bc)
bc <<< "scale=3; $SUM/3"

 echo "=== Run With New Profile (perPodManagementTrue) ==="
VALUE1=$(crucible get metric --period 0EF654AE-0166-11EE-A2EB-F34450C0D826 --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
VALUE2=$(crucible get metric --period 0DE4E88C-0166-11EE-A6E9-F34450C0D826 --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
VALUE3=$(crucible get metric --period 0E8DB48A-0166-11EE-A2EB-F34450C0D826 --source $SOURCE --type $TYPE | grep \"value\" | awk '{print $2}')
SUM=$(echo $VALUE1 + $VALUE2 + $VALUE3 | bc)
bc <<< "scale=3; $SUM/3"
