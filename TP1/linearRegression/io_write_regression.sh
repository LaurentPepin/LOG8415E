#!/bin/bash

INSTANCE=$1
REGRESSION_GRAPH_FILE_NAME="./results/IO_throughput_sampling.csv"

if [ ! -f $WRITE_TEST_FILE_NAME ]; then
    echo "count, throughput" > $REGRESSION_GRAPH_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

for index in {0..5}; do
    count=$(echo "10^"$index | bc)
    #oflag=direct prevents caching
    throughput=$(dd if=/dev/zero of=/tmp/test bs=64K count=$count oflag=direct 2>&1 | sed 1,2d | cut -d ',' -f4 | grep -oP "\d+.*")
    echo $throughput
    echo $count,$throughput >> $REGRESSION_GRAPH_FILE_NAME
done

rm /tmp/test

echo "Samping test over"

git add ./results/IO_throughput_sampling.csv
git commit -m "IO sampling results for $INSTANCE"
git push 
