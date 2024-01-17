#!/bin/bash
#
# Copyright (C) 2024 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

perf_folder=$1
if [ -z "$perf_folder" ]; then
    echo "Perf folder not specified.  Use ./generate-flame.sh <folder-with-perf-results>"
    exit 1
fi
if [ ! -d "$perf_folder" ]; then
    echo "$perf_folder is not a directory, exiting."
    exit 1
fi
if [ ! -f "$perf_folder/perf.data" ]; then
    echo "No perf.data found in $perf_folder, exiting"
    exit 1
fi
if [ ! -d "$SCRIPT_DIR/FlameGraph" ]; then
    echo "FlameGraph repo is missing, cloning the repository..."
    git clone https://github.com/brendangregg/FlameGraph $SCRIPT_DIR
fi

cd $perf_folder
NUMBER_CORE=$(perf script -F cpu |  awk '!a[$0]++' | wc -l)
echo "Generating a Flame Graph for all $NUMBER_CORE cores"
mkdir -p flameResults
for ((i = 0; i < $NUMBER_CORE; i++))
do
    echo "Generating flames for Core $i"
    perf script -C $i | $SCRIPT_DIR/FlameGraph/stackcollapse-perf.pl > flameResults/out.perf-folded
    $SCRIPT_DIR/FlameGraph/flamegraph.pl flameResults/out.perf-folded > flameResults/perf-core-$i.svg
done

rm flameResults/out.perf-folded --force
echo "Done. All the flame graphs are available in the folder $perf_folder/flameResults"

