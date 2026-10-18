import urllib.request
import urllib.parse
import json

API_KEY = "36185ba671ab49ba98bd914e4cdbe3f0"
city = "Karkala"

# 1. Geocode
geo_url = f"https://api.geoapify.com/v1/geocode/search?text={urllib.parse.quote(city)}&format=json&apiKey={API_KEY}"
with urllib.request.urlopen(geo_url) as response:
    geo_data = json.loads(response.read().decode())
    place_id = geo_data['results'][0]['place_id']
    lat = geo_data['results'][0]['lat']
    lon = geo_data['results'][0]['lon']
    print(f"Geocoded {city}: {lat}, {lon} (Place ID: {place_id})")

# 2. Get Hotels
hotel_url = f"https://api.geoapify.com/v2/places?categories=accommodation.hotel,accommodation.guest_house&filter=place:{place_id}&limit=10&apiKey={API_KEY}"
with urllib.request.urlopen(hotel_url) as response:
    hotel_data = json.loads(response.read().decode())
    print("--- Hotels ---")
    for feature in hotel_data['features']:
        print(feature['properties'].get('name', 'Unknown'))

# 3. Get Restaurants
rest_url = f"https://api.geoapify.com/v2/places?categories=catering.restaurant,catering.cafe&filter=place:{place_id}&limit=15&apiKey={API_KEY}"
with urllib.request.urlopen(rest_url) as response:
    rest_data = json.loads(response.read().decode())
    print("--- Restaurants ---")
    for feature in rest_data['features']:
        print(feature['properties'].get('name', 'Unknown'))
