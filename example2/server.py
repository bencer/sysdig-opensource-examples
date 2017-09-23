#!/usr/bin/env python
# -*- coding: utf-8 -*-

from SocketServer import ThreadingMixIn
from SimpleHTTPServer import SimpleHTTPRequestHandler
from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler

import os
import sys
import logging


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class MyRequestHandler(BaseHTTPRequestHandler):

    def foo_handler(self):
        self.send_response(200)
        self.send_header('text/plain', 'Content-type')
        self.end_headers()
        self.wfile.write('foo')
    
    def bar_handler(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write('bar')
    
    def do_GET(self):
        _, mypath= self.path.split('/')

        if mypath == 'foo':
            self.foo_handler()

        if mypath == 'bar':
            self.bar_handler()

class ThreadingSimpleServer(ThreadingMixIn, HTTPServer):
    logger.info('Listening for connections...')
    pass

def main():
    host = '0.0.0.0'
    port = 80

    server = ThreadingSimpleServer((host, port), MyRequestHandler)
    server.serve_forever()

if __name__ == '__main__':
    main()
