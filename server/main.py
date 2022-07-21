
from network import Network
from time import sleep

class LocalHost(Network):
	def __init__( self, ip='127.0.0.1', ports=[] ):
		self.ip = ip
		self.ports = ports

if __name__ == '__main__':
	host = LocalHost(ports=[500])
	host.setup()
	while True:
		# allows keyboard exit
		try:
			sleep(0.1)
		except:
			break
	host.kill()
