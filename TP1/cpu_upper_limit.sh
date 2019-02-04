#!/bin/bash

MAX_PRIME_START=$1
INTERVAL=$2
RESULTS_FILE_NAME=$3

if [[ "$MAX_PRIME_START" == "" && "$INTERVAL" == "" ]]; then
  echo "First parameter is MAX_PRIME_START"
  echo "Second parameter is INTERVAL"
  echo "Third parameter is RESULTS_FILE_NAME"
  exit 1
fi

#apt-get install sysbench --yes

((MAX_PRIME=MAX_PRIME_START))
MAX_TOTAL_TIME=120
TOTAL_TIME=0
echo $MAX_PRIME > $RESULTS_FILE_NAME
while [ "$TOTAL_TIME" -lt "$MAX_TOTAL_TIME" ]
do
  $TOTAL_TIME=(sysbench --test=cpu --cpu-max-prime=2 run | grep "total time:" | grep -oP "\d+\.\d+")
  ((MAX_PRIME=MAX_PRIME+INTERVAL))
  echo $MAX_PRIME >> $RESULTS_FILE_NAME
done



