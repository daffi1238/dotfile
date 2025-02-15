#!/usr/bin/python3
import mmh3
import requests
import codecs
import sys
import os

# Verificar que se haya pasado un argumento (URL o archivo)
if len(sys.argv) != 2:
    print(f"Uso: {sys.argv[0]} <URL o ruta de archivo>")
    sys.exit(1)

input_path = sys.argv[1]

try:
    if input_path.startswith(('http://', 'https://')):
        # Caso: URL
        response = requests.get(input_path)
        response.raise_for_status()  # Lanza un error si la respuesta no es exitosa
        favicon = codecs.encode(response.content, "base64")
    elif os.path.isfile(input_path):
        # Caso: Fichero local
        with open(input_path, "rb") as file:
            favicon = codecs.encode(file.read(), "base64")
    else:
        print("El argumento proporcionado no es una URL válida ni un archivo existente.")
        sys.exit(1)

    # Calcular hash
    hash = mmh3.hash(favicon)
    print(f"Hash (mmh3) de {input_path}: {hash}")

except requests.RequestException as e:
    print(f"Error al obtener la URL: {e}")
except FileNotFoundError:
    print(f"Archivo no encontrado: {input_path}")
except Exception as e:
    print(f"Error inesperado: {e}")

