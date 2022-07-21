

import requests

session = requests.Session()
response = session.get('127.0.0.1:500')

print(response.content)

