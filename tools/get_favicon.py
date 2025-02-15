import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import os
import sys

def get_favicons(url):
    try:
        response = requests.get(url, timeout=5, verify=False)  # Desactivar verificación SSL
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'lxml')

        favicons = []

        # Buscar múltiples tipos de favicon
        for link_tag in soup.find_all('link', rel=True):
            rel = link_tag.get('rel')
            href = link_tag.get('href')
            if href and any(r in rel for r in ['icon', 'shortcut icon', 'apple-touch-icon', 'mask-icon']):
                favicon_url = urljoin(url, href)
                favicons.append({
                    "url": favicon_url,
                    "type": ", ".join(rel),
                    "sizes": link_tag.get('sizes', 'unknown')
                })

        # Añadir favicon estándar si no se encontró ninguno
        if not favicons:
            standard_favicon = urljoin(url, '/favicon.ico')
            favicons.append({
                "url": standard_favicon,
                "type": "standard",
                "sizes": "default"
            })

        return favicons

    except Exception as e:
        print(f"Error obteniendo favicons de {url}: {e}")
        return []

def download_favicons(favicons, domain):
    os.makedirs(f'./icons/{domain}', exist_ok=True)
    for i, favicon in enumerate(favicons):
        try:
            response = requests.get(favicon["url"], stream=True, timeout=5, verify=False)  # Desactivar verificación SSL
            response.raise_for_status()

            file_ext = favicon["url"].split('.')[-1].split('?')[0]
            if file_ext not in ["ico", "png", "jpg", "jpeg", "svg"]:
                file_ext = "ico"
            
            save_path = f'./icons/{domain}/{domain}_{i}_{favicon["sizes"]}.{file_ext}'
            with open(save_path, 'wb') as f:
                for chunk in response.iter_content(1024):
                    f.write(chunk)
            print(f"✅ Descargado: {favicon['url']} ➜ {save_path}")
        except Exception as e:
            print(f"❌ Error descargando {favicon['url']}: {e}")

def main():
    if len(sys.argv) != 2:
        print("Uso: python get_all_favicons.py <URL>")
        return
    
    url = sys.argv[1]
    if not url.startswith('http'):
        url = 'https://' + url

    domain = urlparse(url).netloc.replace("www.", "")
    print(f"🔍 Buscando favicons para: {domain}")
    
    favicons = get_favicons(url)

    if favicons:
        print(f"🌐 Favicons encontrados para {domain}:")
        for i, favicon in enumerate(favicons):
            print(f"[{i+1}] URL: {favicon['url']}, Tipo: {favicon['type']}, Tamaño: {favicon['sizes']}")

        print("\n💾 Descargando favicons...\n")
        download_favicons(favicons, domain)
    else:
        print(f"⚠️ No se encontraron favicons para: {domain}")

if __name__ == '__main__':
    # Desactivar advertencias de certificados SSL
    requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)
    main()
