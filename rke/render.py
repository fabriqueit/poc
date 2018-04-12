import sys
import json
from jinja2 import Environment, FileSystemLoader

if  len(sys.argv) == 2:
    env = Environment(loader=FileSystemLoader('template'))
    template = env.get_template('cluster.yml')

    masters = json.load(open('masters_ips.json'))
    workers = json.load(open('workers_ips.json'))
    user = sys.argv[1]

    result = template.render(masters_ips=masters, workers_ips=workers, user=user).encode('utf8')

    f = open('cluster.yml', 'wb+')
    f.write(result)
    f.close()
else:
    exit("You should specify a user to create the configuration file from the template")
