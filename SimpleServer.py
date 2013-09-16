import SimpleHTTPServer
import SocketServer
import logging
import cgi

PORT = 8000

class ServerHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_OPTIONS(self):           
        self.send_response(200, "ok")       
        self.send_header('Access-Control-Allow-Origin', '*')                
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header("Access-Control-Allow-Headers", "X-Requested-With")  

    def do_GET(self):
        logging.error(self.headers)
        SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)

    def do_POST(self):
        logging.warning("======= POST STARTED =======")        
        logging.warning("======= POST HEADERS =======")
        logging.error(self.headers)
        logging.warning("======= POST CONTENT =======")
        length = int(self.headers['Content-Length'])
        print(length)
        #data1 = self.rfile.read(length).decode('utf-8')
        data1 = self.rfile.read(length)
        print(data1)
        
        #form = cgi.FieldStorage(
          #  fp=self.rfile,
            #headers=self.headers,
            #environ={'REQUEST_METHOD':'POST',
              #       'CONTENT_TYPE':self.headers['Content-Type'],
                #     })
        #for item in form.list:
          #  logging.error(item)
        #SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)

Handler = ServerHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()