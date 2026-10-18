import urllib.request
import urllib.parse
import json

def fetch_names(query):
    url = f"https://nominatim.openstreetmap.org/search?q={urllib.parse.quote(query)}&format=json&limit=30"
    req = urllib.request.Request(url, headers={'User-Agent': 'Test/1.0'})
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            names = []
            for item in data:
                name = item['display_name'].split(',')[0]
                names.append(name)
            print(f"{query}: {', '.join(names[:20])}")
    except Exception as e:
        print(f"Error {query}: {e}")

fetch_names("hotels in Karkala")
fetch_names("restaurants in Karkala")
fetch_names("attractions in Karkala")
