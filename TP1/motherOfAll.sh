#!/bin/bash

INSTANCE=$1

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

yes | ./installation.sh

./cpu_test.sh $INSTANCE

./IO_latency_test.sh $INSTANCE


./IO_read_test.sh $INSTANCE $DISK_PARTITION

./IO_test.sh $INSTANCE

BLOCK_SIZE_1=$(./IO_write_blocksize_test.sh $INSTANCE)

./IO_write_load_test.sh $INSTANCE $BLOCK_SIZE_1

./iops_test.sh $INSTANCE

BLOCK_SIZE_2_READ=$(./memory_read_block_size_test.sh $INSTANCE)
BLOCK_SIZE_2_WRITE=$(./memory_write_block_size_test.sh $INSTANCE)

./memory_read_total_size_test.sh $INSTANCE $BLOCK_SIZE_2_READ
./memory_write_total_size_test.sh $INSTANCE $BLOCK_SIZE_2_WRITE

./network_test.sh $INSTANCE 911
