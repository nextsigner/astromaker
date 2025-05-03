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
                        if a2 == "inter_house_1.html":
                            a6="<h3>Personalidad e impresión hacia los demás</h3>"
                        elif a2 == "inter_house_2.html":
                            a6="<h3>Capacidad de Materializar, recursos, economía, interacción con la naturaleza, belleza y disfrute de la vida</h3>"
                        elif a2 == "inter_house_3.html":
                            a6="<h3>Maneras de expresarse, dialogar, comunicarse, tipo de entorno cercano y modos de ralcionarse, moverse o interactual con el</h3>"
                        elif a2 == "inter_house_4.html":
                            a6="<h3>Tipo de hogar en el que habitas, nido donde te criaste en la infancia, recuerdos y relación con el pasado, la familia, la madre, abuelos o tipos de emociones</h3>"
                        elif a2 == "inter_house_5.html":
                            a6="<h3>Asuntos relacionados con el ego, el auto estima, la identidad, la expresividad, la creatividad, los hijos, el juego, los tipos de romances, las maneras de brillar o ponerse en el centro de la escena</h3>"
                        elif a2 == "inter_house_6.html":
                            a6="<h3>Ámbito laboral, rutinas y salud</h3>"
                        elif a2 == "inter_house_7.html":
                            a6="<h3>Relaciones familiares o importantes, pareja, matrimonio, socios o tipo de relacion con respecto a los demás en general en especial lo que vemos en los demás que nos cuesta ver en nosotros mismos</h3>"
                        elif a2 == "inter_house_8.html":
                            a6="<h3>Asuntos de nuestra vida relacionados con lo oculto, lo que ocultamos, asuntos relacionados con temas tabú, sexo, poder, control, administración, gestión de recursos ajenos o incluso coas de las que podríamos desapegarnos</h3>"
                        elif a2 == "inter_house_9.html":
                            a6="<h3>Asuntos relacionados con los sistemas de creencias, la manera de creer, aprender, expandir la consciencia, las filosofías de vida, los estudios superiores, el acercamiento a la sabiduría, tipo de relación con los maestros, la capacidad de guiar, viajar y esparcir nuestra energía hacia los demás</h3>"
                        elif a2 == "inter_house_10.html":
                            a6="<h3>Asuntos relacionados con la profesión, el trabajo, la relacion con el poder, el gobierno, los jefes y la autoridad en general, la etapa más alta de nuestra vida, nuestros máximos logros y exposición pública</h3>"
                        elif a2 == "inter_house_11.html":
                            a6="<h3>Modos y maneras de relacionarse con los grupos, amistades y organizaciones en donde se podría participar involucrando el ego en un entorno rodeado de otros egos, la integración en donde ir a llevar cambios, libertad, aportar soluciones o ideas para actualizar y mejorar las cosas hacia el futuro</h3>"
                        elif a2 == "inter_house_12.html":
                            a6="<h3>Asuntos relacionados con el desarrollo espiritual, el ser interior, nuestra zona cótica y desconocida, la mente oculta, el inconsciente, lo que vivimos en el vientre materno, la conexión con el árbol genealógico o el más allá</h3>"
                        else:
                            a3=a2.replace('pos_', '<h3>Manifestaciones POSITIVAS de tu ').replace('neg_', '<h3>Manifestaciones NEGATIVAS de tu ').replace('head.html', '2WSAZQ').replace('.html', '')
                            a4=a3.split('_')
                            a5=a3.replace('_'+a4[len(a4)-1], '_Casa_'+a4[len(a4)-1])
                            a6=a5.replace('_', ' ').replace('head', '').replace('foot', '')+'</h3>'
                        if index > 0 and index != len(rutas_archivos)-1:
                            archivo_final.write(a6)
                        #archivo_final.write('<br>')
                        archivo_final.write(contenido2)
                        archivo_final.write('<br>')
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
