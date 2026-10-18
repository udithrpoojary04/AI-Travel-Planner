import urllib.request
import json

def fetch_wiki(city):
    url = f"https://en.wikipedia.org/w/api.php?action=query&prop=extracts&explaintext&titles={city}&format=json"
    req = urllib.request.Request(url, headers={'User-Agent': 'Test/1.0'})
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        pages = data['query']['pages']
        for page_id in pages:
            if page_id == '-1':
                print(f"{city} not found on Wiki.")
            else:
                extract = pages[page_id].get('extract', '')
                print(f"--- {city} Wiki Length: {len(extract)} ---")
                print(extract[:500])

fetch_wiki("Karkala")
fetch_wiki("Moodbidri")
