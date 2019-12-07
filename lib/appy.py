# importing the requests library
import requests
import base64
#the client id and the secret should be locked down.
#  we wouldn't want kroger to retract it from us

# easygrocery-cfaafab63bf618b03b3bb5ce8e9ff8d1
# n806jaTr4XoVYfWmdKgvPWoavdU6XmX5

# https://api.kroger.com/v1/connect/oauth2/token

#the secret is the client-id + the client secret
secret = base64.b64encode('easygrocery-cfaafab63bf618b03b3bb5ce8e9ff8d1:n806jaTr4XoVYfWmdKgvPWoavdU6XmX5')
# standard protocol to have a Basic scheme + secret
auth = 'Basic ' + secret
# api-endpoint that we want to call
URL = "https://api.kroger.com/v1/connect/oauth2/token"
# in reference to https://tools.ietf.org/html/rfc6749#section-1.3.1 -- the stuff we will need
r = requests.post( URL, data = {'grant_type':'client_credentials', 'scope':'product.compact'},
 headers= {'content-type':'application/x-www-form-urlencoded', 'accept':'application/json', 'authorization':auth})

# our payload. we're limited to 200 items per call, start with first item
payload = {'filter.limit':'200', 'filter.start':'0'} # want 200 items starting with the first
# extracting data in json format
data = r.json() # gets us the token we need for authorization
token = 'Bearer ' + data['access_token'] # gives us the access token for getting data

#next, we want the products page
products_url = 'https://api.kroger.com/v1/products'
# and to get the payload, with proper headers per man pages ref'd above.
requests.get(products_url, params = payload, headers={'accept':'applications/json', 'authorization':token})

# pagination_data = r.json()['meta']['pagination']
# payload['filter.start'] = pagination_data['limit']

# there are 282027 total items.
# when limit = total, we've found them all. we have to change the meta pagination start to the
# meta pagination limit. keep the limit at 200 (the most items you can get at once)
# but loop through so that we keep making calls until we've got all items
# for payload in pagination_data:
#     payload['filter.start'] = pagination_data['limit']
#     if pagination_data['limit'] >= pagination_data['total']:
#         break


print(data)

