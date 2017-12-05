#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

import random
import os
import sys

host = os.environ['SERVER_HOST'] + ':' + os.environ['SERVER_PORT']
count = 1000

def randomURL():
    available_endpoints = ['fib', 'empty', 'download']
    endpoint = random.choice(available_endpoints)
    number = random.randint(1, 1024)
    url = 'http://{}/{}/{}'.format(host, endpoint, number)
    return url

with open('urls.txt', 'a') as urls:
    for i in range(count):
        url = randomURL()
        urls.write(url+'\n')
