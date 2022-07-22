
from network import Network
from time import sleep

if __name__ == '__main__':
	host = Network(ports=[500])
	host.setup()
	while True:
		# allows keyboard exit
		try:
			sleep(0.1)
		except:
			break
	host.kill()
