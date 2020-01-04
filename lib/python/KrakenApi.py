import pyotherside
import krakenex

class KrakenApi:
    def __init__(self):
        self.key = None
        self.secret = None

    def set_keys(self, key, secret):
        self.key = key
        self.secret = secret

    def query_public(self, method, data=None, timeout=None):
        api = krakenex.API()
        return api.query_public(method, data, timeout)

    def query_private(self, method, data=None, timeout=None):
        api = krakenex.API(self.key, self.secret)
        return api.query_private(method, data, timeout)

api = KrakenApi()
