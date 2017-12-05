#!/bin/sh
cd /tmp/
python gen_url_list.py
tail -n 10 urls.txt
sleep 30
siege -v -c 5 -f urls.txt
