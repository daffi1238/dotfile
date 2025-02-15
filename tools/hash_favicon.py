#!/usr/bin/python3
import mmh3
import requests
import codecs
import sys

# Verificar que se haya pasado la URL como argumento
if len(sys.argv) != 2:
    print(f"Uso: {sys.argv[0]} <URL>")
    sys.exit(1)

url = sys.argv[1]

try:
    response = requests.get(url)
    response.raise_for_status()  # Lanza un error si la respuesta no es exitosa
    favicon = codecs.encode(response.content, "base64")
    hash = mmh3.hash(favicon)
    print(f"{url}: {hash}")
except requests.RequestException as e:
    print(f"Error al obtener la URL: {e}")
except Exception as e:
    print(f"Error inesperado: {e}")
