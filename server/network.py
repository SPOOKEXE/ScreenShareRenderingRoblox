
import socket
import json
import _thread
import time

import screenshot
from compression import compress

# finish_key = '5e100"'
# def recieve_all(connection):
# 	data = []
# 	raw = None
# 	while 1:
# 		# recieve
# 		chunk = connection.recv(512)
# 		if not chunk:
# 			break
# 		chunk : str = chunk.decode('utf-8')
# 		# append
# 		data.append(chunk)
# 		# format data
# 		raw = "".join(data)
# 		# check if finished
# 		index = raw.find(finish_key)
# 		if index != -1 or chunk == '\n':
# 			break
# 	return raw

class Network:
	ip = None
	ports = None

	__sockets = []
	__threads = []
	__hasSetup = False

	# On Incoming Data
	def __compileSendData(self):
		# return dumped json string w/ data
		data, _ = screenshot.Get()
		data = compress(data)
		# TODO: data compression + uncompression
		return json.dumps({
			"Timestamp": time.time(),
			"Data" : str(data)
		})

	# Setup socket handling
	def __setup_network_handle(self):
		while True:
			for sock in self.__sockets:
				conn, addr = sock.accept()
				# _ = recieve_all(conn)
				print("Connection started; ", addr)
				returnData = self.__compileSendData()
				response_headers = { 'Content-Type': 'application/json; encoding=utf8', 'Content-Length': len(returnData), 'Connection': 'close' }
				response_headers_raw = ''.join('%s: %s\n' % (k, v) for k, v in response_headers.items())
				conn.send('HTTP/1.1 200 OK'.encode())
				conn.send(response_headers_raw.encode())
				conn.send('\n'.encode()) # to separate headers from body
				conn.sendall(str(returnData).encode())
				print("Close Connection")
				time.sleep(3)
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

if __name__ == '__main__':
	from time import sleep

	host = Network(ports=[500])
	host.setup()
	while True:
		# allows keyboard exit
		try:
			sleep(0.1)
		except:
			break
	host.kill()
