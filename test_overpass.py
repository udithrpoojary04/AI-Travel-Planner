import urllib.request
import urllib.parse
import json

lat = 13.2145414
lon = 74.9951861

query = f"""
[out:json];
(
  node["amenity"="restaurant"](around:5000,{lat},{lon});
  node["tourism"="hotel"](around:5000,{lat},{lon});
  node["tourism"~"attraction|museum|viewpoint"](around:5000,{lat},{lon});
  node["historic"](around:5000,{lat},{lon});
);
out tags;
"""

url = f"https://overpass-api.de/api/interpreter?data={urllib.parse.quote(query)}"
req = urllib.request.Request(url, headers={'User-Agent': 'Test/1.0'})
with urllib.request.urlopen(req) as response:
    data = json.loads(response.read().decode())
    for elem in data.get('elements', []):
        tags = elem.get('tags', {})
        if 'name' in tags:
            print(f"Name: {tags['name']}")
