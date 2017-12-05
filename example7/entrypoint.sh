#!/bin/sh

cd /usr/src/app
echo running mapreduce and aggregate
python mapreduce.py > /dev/null &
python aggregate.py > /dev/null &

while /bin/true; do
  sleep 60
done
