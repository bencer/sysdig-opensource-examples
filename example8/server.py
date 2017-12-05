#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sysdig_tracers import Tracer, Args, ReturnValue

# sorry, using simple stuff rather than Twisted, Tornado or Python3 asyncio
from SocketServer import ThreadingMixIn
from SimpleHTTPServer import SimpleHTTPRequestHandler
from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler

import os
import sys
import gzip
import random
import tempfile
import logging


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# fibonacci method to show case decorators with enter and exit args
@Tracer(enter_args={"n": Args(0)}, exit_args={"ret": ReturnValue})
def fib(n):
    a, b = 1, 1
    for i in range(n-1):
        a, b = b, a+b
    return a


class MyRequestHandler(BaseHTTPRequestHandler):

    def do_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()

    # return the fibonacci number
    def fib_handler(self, num):
        with Tracer("fib_handler") as t:
            with t.span("fib_headers"):
                self.do_headers()
    
            with t.span("fib_write"):
                result = fib(num)
                self.wfile.write(result)
    
    # return an empty response
    def empty_handler(self, num):
        with Tracer("empty_handler") as t:
            with t.span("empty_headers"):
                self.do_headers()
    
            with t.span("empty_write"):
                self.wfile.write("")

    @Tracer(enter_args={"n": Args(1)}, exit_args={"ret": ReturnValue})
    def do_download_write(self, filename):
        with open(filename, 'r') as f:
            self.wfile.write(f.read())

    # randomly download a file between a collection of 4
    def download_handler(self, num):
        with Tracer("download_handler") as t:
            with t.span("download_headers"):
                self.do_headers()
    
            with t.span("download_write"):
                filename = '/tmp/blob.bin.{}'.format(random.randint(1,4))
                self.do_download_write(filename)

    def do_GET(self):
        _, driver, num = self.path.split('/')
        num = int(num)

        if driver == 'fib':
            self.fib_handler(num)

        if driver == 'empty':
            self.empty_handler(num)

        if driver == 'download':
            self.download_handler(num)


class ThreadingSimpleServer(ThreadingMixIn, HTTPServer):
    logger.info('Listening for connections...')
    pass


def init_file(file_path, size, compress=False):
    file_raw_path = file_path+'.raw'
    with open(file_raw_path, "wb") as out:
       out.truncate(1024 * size)
    if compress:
        f_in = open(file_raw_path)
        f_out = gzip.open(file_path, 'wb')
        f_out.writelines(f_in)
        f_out.close()
        f_in.close()
    else:
        os.rename(file_raw_path, file_path)

def init_server():
    logger.info('Creating static files...')
    init_file('/tmp/blob.bin.1', 1024)
    init_file('/tmp/blob.bin.2', 1536)
    init_file('/tmp/blob.bin.3', 1280)
    init_file('/tmp/blob.bin.4', 1024*128)

def main():

    host = '0.0.0.0'
    port = 8888

    init_server()
    server = ThreadingSimpleServer((host, port), MyRequestHandler)
    server.serve_forever()

if __name__ == '__main__':
    main()
