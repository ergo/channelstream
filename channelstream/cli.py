from gevent import monkey

monkey.patch_all()

import ConfigParser
import collections
import logging
import argparse

from gevent.server import StreamServer
from geventwebsocket import WebSocketServer, Resource
from pyramid.settings import asbool
from channelstream.gc import gc_conns_forever, gc_users_forever
from channelstream.policy_server import client_handle
from channelstream.wsgi_app import make_app
from channelstream.ws_app import ChatApplication


log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

def cli_start():
    config = {
        'secret': '',
        'admin_secret': '',
        'gc_conns_after': 30,
        'gc_channels_after': 3600 * 72,
        'wake_connections_after': 5,
        'allow_posting_from': [],
        'port': 8000,
        'host': '0.0.0.0',
        'debug': False
    }

    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--ini", dest="ini",
                        help="config file location",
                        default=None)
    parser.add_argument("-s", "--secret", dest="secret",
                        help="secret used to secure your requests",
                        default='secret')
    parser.add_argument("-a", "--admin_secret", dest="admin_secret",
                        help="secret used to secure your admin_panel",
                        default='admin_secret')
    parser.add_argument("-o", "--o", dest="host",
                        help="host ip on which the server listens to",
                        default='0.0.0.0')
    parser.add_argument("-p", "--port", type=int, dest="port",
                        help="port on which the server listens to",
                        default=8000)
    parser.add_argument("-d", "--debug", dest="debug",
                        help="debug",
                        default=0)
    parser.add_argument("-e", "--demo", dest="demo",
                        help="demo enabled",
                        default=False)
    parser.add_argument("-x", "--allowed_post_ip", dest="allow_posting_from",
                        help="comma separated list of ip's "
                             "that can post to server",
                        default="127.0.0.1"
                        )
    args = parser.parse_args()
    if args.ini:
        parser = ConfigParser.ConfigParser()
        parser.read(args.ini)

        non_optional_parameters = (
            'debug', 'port', 'host', 'secret', 'admin_secret',
            'demo_app_url', 'demo')
        for key in non_optional_parameters:
            try:
                config[key] = parser.get('channelstream', key)
            except ConfigParser.NoOptionError:
                pass

        try:
            ips = [ip.strip() for ip in parser.get(
                'channelstream', 'allow_posting_from').split(',')]
            config['allow_posting_from'].extend(ips)
        except ConfigParser.NoOptionError:
            pass

    else:
        config['debug'] = int(args.debug)
        config['port'] = int(args.port)
        config['demo'] = asbool(args.demo)
        config['host'] = args.host
        config['secret'] = args.secret
        config['admin_secret'] = args.admin_secret
        config['allow_posting_from'].extend(
            [ip.strip() for ip in args.allow_posting_from.split(',')])
    log_level = logging.DEBUG if config['debug'] else logging.INFO
    logging.basicConfig(level=log_level)

    url = 'http://{}:{}'.format(config['host'], int(config['port']))

    if config['demo']:
        log.info('Demo enabled, visit {}/demo'.format(url))

    log.info('Starting flash policy server on port 10843')
    gc_conns_forever()
    gc_users_forever()
    server = StreamServer(('0.0.0.0', 10843), client_handle)
    server.start()
    log.info('Serving on {}'.format(url))
    app_dict = collections.OrderedDict({
        '^/ws.*': ChatApplication,
        '^/*': make_app(config)
    })
    WebSocketServer(
        (config['host'], int(config['port'])),
        Resource(app_dict),
        debug=False
    ).serve_forever()
