import requests
import sys

file_name = sys.argv[1]
scan_type = ''

#if file_name == 'gitleaks.json':
#    scan_type = 'Gitleaks Scan'
#elif file_name == 'semgrep.json':
#    scan_type = 'Semgrep JSON Report'
if file_name == 'semgrep.json':
    scan_type = 'Semgrep JSON Report'

headers = {
        'content-type': 'application/json',
        'Authorization': 'Token <hash>'
#        'username': '',
#        'password': ''
        }

#url = 'http://51.250.92.214:8080/api/key-v2/import-scan/'
url = 'http://51.250.92.214:8080/api/v2/import-scan/'

data = {
        'active': True,
        'verified': True,
        'scan_type': scan_type,
        'minimum_serevity': 'Low',
        'engagement_id': 5,
        'product_id': 2
        }

files = {
        'file': open(file_name, 'rb')
        }

response = requests.post(url, headers=headers, data=data, files=files)

if response.status_code == 201:
    print('Scan results imported successfully')
else:
    print(f"'Failed to import scan results: {response.content}'")




#How to run >
# pip3 install requests
# python3 upload_reports.py gitleaks.json
# python3 upload_reports.py semgrep.json
