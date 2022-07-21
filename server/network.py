
import socket
import json
import _thread
import time

import screenshot

class Network:
	ip = None
	ports = None

	__sockets = []
	__threads = []
	__hasSetup = False

	# On incoming Data
	def __compileSendData(self):
		# get latest screenshot
		screenshot.Update()
		# return dumped json string w/ data
		return json.dumps({
			"Timestamp": time.time(),
			"Data" : str(screenshot.GetRaw())
		})

	# Setup socket handling
	def __setup_network_handle(self):
		while True:
			for sock in self.__sockets:
				conn, addr = sock.accept()
				print("Connection started; ", addr)
				returnData = self.__compileSendData()
				response_headers = { 'Content-Type': 'application/json; encoding=utf8', 'Content-Length': len(returnData), 'Connection': 'close' }
				response_headers_raw = ''.join('%s: %s\n' % (k, v) for k, v in response_headers.items())
				conn.sendall('HTTP/1.1 200 OK'.encode())
				conn.sendall(response_headers_raw.encode())
				conn.sendall('\n'.encode()) # to separate headers from body
				conn.sendall(str(returnData).encode())
				print("Close Connection")
				conn.close()

	def setup( self ):
		# prevent multiple occurences
		if self.__hasSetup:
			return
		self.__hasSetup = True
		# setup ports
		for portNumber in self.ports:
			print(self.ip + ":" + str(portNumber))
			newSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			newSocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
			newSocket.bind((self.ip, portNumber))
			newSocket.listen(1)
			self.__sockets.append(newSocket)
		# create a thread for handling the sockets
		self.__threads.append( _thread.start_new_thread(self.__setup_network_handle, ()) ) 
		print("Total of " + str(len(self.ports)) + " ports opened.")

	def kill( self ):
		# kill threads
		for thread in self.__threads:
			thread.exit()
		# close sockets
		for sock in self.__sockets:
			sock.shutdown(socket.SHUT_RDWR)

	# initialise
	def __init__( self, ip='127.0.0.1', ports=[] ):
		self.ip = ip
		self.ports = ports
