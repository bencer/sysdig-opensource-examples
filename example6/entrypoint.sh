#!/bin/sh
cd /usr/src/demo
echo running write app
./write
echo finished running write app
sleep 10
echo running fwrite app
./fwrite
echo finished running fwrite app
