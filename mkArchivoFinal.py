import sys

def combinar_archivos(archivo_destino, lista_archivos):
    index=0
    try:
        rutas_archivos = lista_archivos.split(',')
        with open(archivo_destino, 'w') as archivo_final:
            for ruta_archivo in rutas_archivos:
                try:
                    with open(ruta_archivo.strip(), 'r') as archivo_origen:
                        contenido = archivo_origen.read()
                        contenido2 = contenido.replace('```html', '').replace('```', '').replace('head', '').replace('foot', '')
                        a1=ruta_archivo.strip().split('/')
                        a2=a1[int(len(a1)-1)]
                        #print(f"\na2: {a2}")
                        if a2 == "inter_house_6.html":
                            a6="<h3>Ámbito laboral, rutinas y salud</h3>"
                        else:
                            a3=a2.replace('pos_', '<h3>Manifestaciones POSITIVAS de tu ').replace('neg_', '<h3>Manifestaciones NEGATIVAS de tu ').replace('head.html', '2WSAZQ').replace('.html', '')
                            a4=a3.split('_')
                            a5=a3.replace('_'+a4[len(a4)-1], '_Casa_'+a4[len(a4)-1])
                            a6=a5.replace('_', ' ').replace('head', '').replace('foot', '')+'</h3>'
                        if index > 0 and index != len(rutas_archivos)-1:
                            archivo_final.write(a6)
                        archivo_final.write('<br>')
                        archivo_final.write(contenido2)
                        #archivo_final.write('\n')
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
    if len(sys.argv) == 3:
        nombre_archivo_destino = sys.argv[1]
        rutas_archivos = sys.argv[2]
        combinar_archivos(nombre_archivo_destino, rutas_archivos)
    else:
        print("Uso: python script.py <archivo_destino> <ruta_archivo1,ruta_archivo2,...>")
        print("Ejemplo: python combinar.py archivo_final.html /home/usuario/archivo1.html,/datos/archivo2.html,/tmp/archivo3.html")
