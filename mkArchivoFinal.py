import sys

def combinar_archivos(archivo_destino, lista_archivos):
    try:
        rutas_archivos = lista_archivos.split(',')
        with open(archivo_destino, 'w') as archivo_final:
            for ruta_archivo in rutas_archivos:
                try:
                    with open(ruta_archivo.strip(), 'r') as archivo_origen:
                        contenido = archivo_origen.read()
                        a1=ruta_archivo.strip().split('/')
                        a2=a1[int(len(a1)-1)]
                        a3=a2.replace('pos_', 'Estas son las manifestaciones POSITIVAS de tu ').replace('neg_', 'Estas son las manifestaciones NEGATIVAS de tu ').replace('.txt', '')
                        a4=a3.split('_')
                        a5=a3.replace('_'+a4[len(a4)-1], '_Casa_'+a4[len(a4)-1])
                        a6=a5.replace('_', ' ')
                        archivo_final.write(a6)
                        archivo_final.write('\n\n')
                        archivo_final.write(contenido)
                        archivo_final.write('\n')
                    print(f"Se leyó y agregó el contenido de: {ruta_archivo.strip()}")
                except FileNotFoundError:
                    print(f"¡Error! No se encontró el archivo: {ruta_archivo.strip()}")
                except Exception as e:
                    print(f"¡Error al leer el archivo {ruta_archivo.strip()}: {e}")
        print(f"\n¡Proceso completado! El contenido de los archivos se ha guardado en: {archivo_destino}")

    except Exception as e:
        print(f"¡Ocurrió un error general: {e}")

if __name__ == "__main__":
    if len(sys.argv) == 3:
        nombre_archivo_destino = sys.argv[1]
        rutas_archivos = sys.argv[2]
        combinar_archivos(nombre_archivo_destino, rutas_archivos)
    else:
        print("Uso: python script.py <archivo_destino> <ruta_archivo1,ruta_archivo2,...>")
        print("Ejemplo: python combinar.py archivo_final.txt /home/usuario/archivo1.txt,/datos/archivo2.txt,/tmp/archivo3.txt")
