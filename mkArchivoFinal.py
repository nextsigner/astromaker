import sys

def comienza_con_h3_espacio(texto):
  """
  Verifica si un string comienza con el substring '<h3 '.

  Args:
    texto: El string que se va a verificar.

  Returns:
    True si el string comienza con '<h3 ', False en caso contrario.
  """
  if texto.startswith("<h3 "):
    return True
  else:
    return False

def combinar_archivos(archivo_destino, lista_archivos, array_titulos):
    index=0
    try:
        rutas_archivos = lista_archivos.split(',')
        aTits = array_titulos.split(',')
        with open(archivo_destino, 'w') as archivo_final:
            for ruta_archivo in rutas_archivos:
                try:
                    with open(ruta_archivo.strip(), 'r') as archivo_origen:
                        contenido = archivo_origen.read()
                        contenido2 = contenido.replace('```html', '').replace('```', '')
                        #archivo_final.write('<hr>')
                        if comienza_con_h3_espacio(aTits[index]):
                            archivo_final.write('<br>')
                            archivo_final.write('<hr>')
                            archivo_final.write('<a href="#0" style="color: #ff8833;">Volver al Inicio</a>')
                            archivo_final.write(aTits[index].replace('@', ','))
                            archivo_final.write(contenido2)
                        else:
                            archivo_final.write(aTits[index].replace('@', ','))
                            archivo_final.write(contenido2)
                            archivo_final.write('<hr>')
                        archivo_final.write('<br>')
                        index=index+1
                except FileNotFoundError:
                    print(f"¡Error! No se encontró el archivo: {ruta_archivo.strip()}")
                except Exception as e:
                    print(f"¡Error al leer el archivo {ruta_archivo.strip()}: {e}")
        print(f"\n¡Proceso completado! El contenido de los archivos se ha guardado en: {archivo_destino}")
        print(f"\nUrl de Carta: file://{archivo_destino}")

    except Exception as e:
        print(f"¡Ocurrió un error general: {e}")

if __name__ == "__main__":
    if len(sys.argv) == 4:
        nombre_archivo_destino = sys.argv[1]
        rutas_archivos = sys.argv[2]
        array_titulos = sys.argv[3]
        combinar_archivos(nombre_archivo_destino, rutas_archivos, array_titulos)
    else:
        print("Uso: python script.py <archivo_destino> <ruta_archivo1,ruta_archivo2,...> <tit_1, tit2,...>")
        print("Ejemplo: python combinar.py archivo_final.html /home/usuario/archivo1.html,/datos/archivo2.html,/tmp/archivo3.html")
