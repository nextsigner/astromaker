import base64
import sys

def convertir_png_a_base64(ruta_imagen):
  try:
    with open(ruta_imagen, "rb") as imagen_file:
      imagen_codificada = base64.b64encode(imagen_file.read()).decode('utf-8')
      return f"data:image/png;base64,{imagen_codificada}"
  except FileNotFoundError:
    print(f"Error: No se encontró el archivo en la ruta: {ruta_imagen}")
    return None
  except Exception as e:
    print(f"Ocurrió un error al procesar {ruta_imagen}: {e}")
    return None
"""
if __name__ == "__main__":
  if len(sys.argv) < 2:
    print("Uso: python script.py ruta1.png,ruta2.png,ruta3.png,...")
    sys.exit(1)

  rutas_str = sys.argv[1]
  rutas_png = [ruta.strip() for ruta in rutas_str.split(',')]

  codigo_html = ""
  for ruta in rutas_png:
    codigo_base64 = convertir_png_a_base64(ruta)
    if codigo_base64:
      codigo_html += f'<img src="{codigo_base64}" style="width: 100%;" alt="Imagen">\n'

  if codigo_html:
    print("Código HTML generado:")
    print(codigo_html)
  else:
    print("No se generó ningún código HTML.")
"""



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

def combinar_archivos(archivo_destino, lista_archivos, array_titulos, array_imgs):
    index=0
    indexImg=0
    try:
        rutas_archivos = lista_archivos.split(',')
        aTits = array_titulos.split(',')
        aPngs = array_imgs.split(',')
        with open(archivo_destino, 'w') as archivo_final:
            for ruta_archivo in rutas_archivos:
                try:
                    with open(ruta_archivo.strip(), 'r') as archivo_origen:
                        contenido = archivo_origen.read()
                        contenido2 = contenido.replace('```html', '').replace('```', '')
                        if comienza_con_h3_espacio(aTits[index]):
                            archivo_final.write('<br>')
                            archivo_final.write('<hr>')
                            archivo_final.write('<a href="#0" style="color: #ff8833;">Volver al Inicio</a>')
                            t=aTits[index].replace('@', ',')#.replace('CASA 1:', '').replace('CASA 2:', '').replace('CASA 3:', '').replace('CASA 4:', '').replace('CASA 5:', '').replace('CASA 6:', '').replace('CASA 7:', '').replace('CASA 8:', '').replace('CASA 9:', '').replace('CASA 10:', '').replace('CASA 11:', '').replace('CASA 12:', '')
                            archivo_final.write(t)
                            if index > 1:
                                codigo_base64 = convertir_png_a_base64(aPngs[indexImg])
                                codigo_html=''
                                if codigo_base64:
                                  codigo_html += f'<img src="{codigo_base64}" style="width: 100%;" alt="Imagen">\n'
                                  archivo_final.write(codigo_html)
                                indexImg=indexImg+1
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
                    print(f"¡Error al leer el archivo {ruta_archivo.strip()}: {e}\n")
        print(f"\n¡Proceso completado! El contenido de los archivos se ha guardado en: {archivo_destino}")
        print(f"\nUrl de Carta: file://{archivo_destino}")

    except Exception as e:
        print(f"¡Ocurrió un error general: {e}")

if __name__ == "__main__":
    if len(sys.argv) == 5:
        nombre_archivo_destino = sys.argv[1]
        rutas_archivos = sys.argv[2]
        array_titulos = sys.argv[3]
        array_imgs = sys.argv[4]
        combinar_archivos(nombre_archivo_destino, rutas_archivos, array_titulos, array_imgs)
    else:
        print("Uso: python script.py <archivo_destino> <ruta_archivo1,ruta_archivo2,...> <tit_1, tit2,...> <img1.png, img2.png, img3.png>" )
        print("Ejemplo: python combinar.py archivo_final.html /home/usuario/archivo1.html,/datos/archivo2.html,/tmp/archivo3.html" "tit1, tit2, tit3" "img1.png, img3.png, img2.png")
