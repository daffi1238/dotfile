import requests
from bs4 import BeautifulSoup
import sys

def fetch_certificates(domain, unique=False):
    url = f"https://crt.sh/?q={domain}"
    response = requests.get(url)

    if response.status_code != 200:
        print("Error fetching the page")
        sys.exit(1)

    soup = BeautifulSoup(response.content, 'html.parser')

    tables = soup.find_all('table')
    if len(tables) < 2:
        print("No certificate table found.")
        sys.exit(1)

    cert_table = tables[1]
    rows = cert_table.find_all('tr')[1:]

    domains = set()
    for row in rows:
        cols = row.find_all('td')
        if len(cols) >= 6:
            common_name = cols[4].get_text(strip=True)
            matching_identities = cols[5].get_text(separator="\n", strip=True)
            if unique:
                domains.add(common_name)
                domains.update(matching_identities.split("\n"))
            else:
                print(f"Common Name: {common_name}")
                print("Matching Identities:")
                print(matching_identities)
                print("-" * 50)

    if unique:
        for domain in sorted(domains):
            print(domain)

if __name__ == "__main__":
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Uso: python crtsh_scraper.py <dominio> [--unique]")
        sys.exit(1)

    domain = sys.argv[1]
    unique = len(sys.argv) == 3 and sys.argv[2] == "--unique"
    fetch_certificates(domain, unique)
