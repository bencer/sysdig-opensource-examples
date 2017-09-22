#!/bin/sh

cd /usr/src/app
echo running filldata.rb
ruby filldata.rb
echo finished filldata.rb
sleep 5
echo running maprduce.rb and aggregate.rb
ruby mapreduce.rb > /dev/null &
ruby aggregate.rb > /dev/null &

while /bin/true; do
  sleep 60
done
