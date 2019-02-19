#!/bin/bash
INSTANCE=$1
WRITE_TEST_FILE_NAME="./results/cpu_results_$INSTANCE.csv"

if [ ! -f $WRITE_TEST_FILE_NAME ]; then
	echo "instance","time" > $WRITE_TEST_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

computationTime=$(sysbench --max-time=1 cpu --cpu-max-prime=150970010 run | grep "total time:" | grep -oP "\d+.\d+" | cut -d '.' -f1)
echo $INSTANCE,$computationTime >> $WRITE_TEST_FILE_NAME