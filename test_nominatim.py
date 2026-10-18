import urllib.request
import json

def search(q):
    url = f"https://nominatim.openstreetmap.org/search?q={urllib.parse.quote(q)}&format=json&limit=5"
    req = urllib.request.Request(url, headers={'User-Agent': 'Test'})
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        print(f"--- {q} ---")
        for item in data:
            print(item['display_name'])

search("restaurants in Karkala")
search("hotels in Karkala")
search("attractions in Karkala")
