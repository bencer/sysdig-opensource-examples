#!/usr/bin/env python
# -*- coding: utf-8 -*-

from BaseHTTPServer import BaseHTTPRequestHandler

import urlparse
import os


class GetHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        try:
            parsed_path = urlparse.urlparse(self.path)
            message_parts = [
                    'CLIENT VALUES:',
                    'client_address=%s (%s)' % (self.client_address,
                                                self.address_string()),
                    'command=%s' % self.command,
                    'path=%s' % self.path,
                    'real path=%s' % parsed_path.path,
                    'query=%s' % parsed_path.query,
                    'request_version=%s' % self.request_version,
                    '',
                    'SERVER VALUES:',
                    'server_version=%s' % self.server_version,
                    'sys_version=%s' % self.sys_version,
                    'protocol_version=%s' % self.protocol_version,
                    '',
                    'HEADERS RECEIVED:',
                    ]
            for name, value in sorted(self.headers.items()):
                message_parts.append('%s=%s' % (name, value.rstrip()))
            message_parts.append('')
            message = '\r\n'.join(message_parts)

            fd = os.open('server.log', os.O_RDWR|os.O_CREAT)
            os.write(fd, "serving request: %s for client %s\n" % (parsed_path.path, self.client_address))

            self.send_response(200)
            self.end_headers()
            self.wfile.write(message)
        except:
            print "oh! something failed :("
        return

if __name__ == '__main__':
    from BaseHTTPServer import HTTPServer
    server = HTTPServer(('0.0.0.0', 8080), GetHandler)
    server.serve_forever()
