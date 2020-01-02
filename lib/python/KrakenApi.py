import pyotherside
import krakenex

class KrakenApi:
  def __init__(self):
    return None

  def balance(self, key, secret):
      k = krakenex.API(key, secret)
      return k.query_private('Balance')

krakenapi = KrakenApi()
