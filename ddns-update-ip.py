# Stripped down version of https://github.com/rmarchant/gandi-ddns
# Under MIT license

import configparser as configparser
import sys
import os
import requests
import socket
import json
from datetime import datetime
import time

config_file = "ddns-config.txt"

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

class GandiDdnsError(Exception):
    pass

def get_ip(hostname):
    return socket.gethostbyname(hostname)

def read_config(config_path):
    # Read configuration file
    cfg = configparser.ConfigParser()
    cfg.read(config_path)

    return cfg

def get_record(url, headers):
    # Get existing record
    r = requests.get(url, headers=headers)

    return r

def update_record(url, headers, payload):
    # Add record
    r = requests.put(url, headers=headers, json=payload)
    if r.status_code != 201:
        print(('Record update failed with status code: %d' % r.status_code))
        print((r.text))
        sys.exit(2)
        print('Zone record updated.')

    return r

def main():
    path = config_file
    if not path.startswith('/'):
        path = os.path.join(SCRIPT_DIR, path)
    config = read_config(path)
    if not config:
        sys.exit("Please fill in the 'config.txt' file.")

    for section in config.sections():
        print('%s - section %s' % (str(datetime.now()), section))

        # Retrieve API key
        apikey = config.get(section, 'apikey')

        # Set headers
        headers = {'Content-Type': 'application/json', 'Authorization': 'Apikey %s' % apikey}

        a_name = socket.gethostname()
        domain = config.get(section, 'domain')

        # Set URL
        url = '%sdomains/%s/records/%s/A' % (config.get(section, 'gandi_api'),
                                             domain, a_name)
        print(url)
        # Discover External IP
        external_ip = get_ip(a_name + '.' + domain)
        print(('External IP is: %s' % external_ip))

        # Prepare record
        payload = {'rrset_ttl': config.get(section, 'ttl'), 'rrset_values': [external_ip]}

        # Check current record
        record = get_record(url, headers)

        if record.status_code == 200:
            print(('Current record value is: %s' % json.loads(record.text)['rrset_values'][0]))
            if(json.loads(record.text)['rrset_values'][0] == external_ip):
                print('No change in IP address. Goodbye.')
                continue
        else:
            print('No existing record. Adding...')

        update_record(url, headers, payload)


if __name__ == "__main__":
    main()
