#!/bin/sh
cd /usr/src/demo
echo running write app
./write
echo finished running write app
sleep 10
echo running fwrite app
./fwrite
echo finished running fwrite app
sleep 10
echo running write2 app
./write2
echo finished running write2 app
sleep 10
echo running fwrite2 app
./fwrite2
echo finished running fwrite2 app
