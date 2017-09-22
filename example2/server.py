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

    def do_headers(self):
        self.send_response(200)
        self.send_header('text/plain', 'Content-type')
        self.end_headers()

    def foo_handler(self):
        self.do_headers()
        self.wfile.write('foo')
    
    def do_GET(self):
        self.foo_handler()

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
