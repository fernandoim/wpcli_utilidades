""" Devuelve una lista de palabras clave a partir de una o varias palabras clave indicadas como argumentos.
    Este listado de palabras clave se basa en las sugerencias de Google.
"""

import requests, json
import sys

# -*- coding: utf-8 -*-

def muestra_ayuda():
    """ Muestra la ayuda del script."""
    print("Recibe una o más palabras y devuelve un listado con sugerencias de palabras clave.")


numero_de_parametros = len(sys.argv)


palabras = sys.argv[1:numero_de_parametros]
busqueda = ""

for palabra in palabras:
    if palabra == "-h":
        muestra_ayuda()
        sys.exit(0)
    else:
        busqueda = busqueda + " " + palabra

tambusqueda = len(busqueda)
busqueda = busqueda[1:tambusqueda]

URL="http://suggestqueries.google.com/complete/search?client=firefox&q=" + busqueda
cabecera = {'User-agent':'Mozilla/5.0'}
respuesta = requests.get(URL, headers=cabecera)
resultado = json.loads(respuesta.content.decode('utf-8'))
primera_ronda = resultado.pop(1)
palabras_clave = primera_ronda

for i in range(1,3):
    for elemento in palabras_clave:
        URL="http://suggestqueries.google.com/complete/search?client=firefox&q=" + elemento
        cabecera = {'User-agent':'Mozilla/5.0'}
        respuesta = requests.get(URL, headers=cabecera)
        resultado = json.loads(respuesta.content.decode('utf-8'))
        temporal = resultado.pop(1)
        temporal += palabras_clave
        palabras_clave = list(set(temporal))

print("Localizadas " + str(len(palabras_clave)) + " palabras clave derivadas de " + busqueda + ":")
for palabra_clave in palabras_clave:
    print(palabra_clave)
