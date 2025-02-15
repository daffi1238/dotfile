import mmh3
import requests
import codecs
import sys

# Verificar si se pasó la URL como argumento
if len(sys.argv) != 2:
    print("Uso: python3 hash_favicon.py <URL_ico_file>")
    sys.exit(1)

url = sys.argv[1]

# Obtener el favicon desde la URL proporcionada
response = requests.get(f'{url}')
favicon = codecs.encode(response.content, "base64")

# Calcular el hash mmh3
hash = mmh3.hash(favicon)
print(f"Hash mmh3 del favicon de {url}: {hash}")
