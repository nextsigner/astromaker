import sys

CONSULTA=sys.argv[1]
if CONSULTA != "asps":
    SALIDA='<h3>Contenido Dev</3>'
    SALIDA+='<p><b>Consulta: </b>'
    SALIDA+=CONSULTA
    SALIDA+='</p>'
else:
    SALIDA="""Sol conjunción Juno
Sol sextil Marte
Sol sextil Júpiter
Sol cuadratura Saturno
Sol trígono Venus
Luna sextil Urano
Luna sextil Selena
Luna conjunción Nodo Norte
Luna oposición Sol
Mercurio conjunción Juno
Mercurio sextil Marte
Mercurio sextil Júpiter
Mercurio cuadratura Saturno
Venus sextil Saturno
Venus trígono Sol
Venus cuadratura Marte
Venus cuadratura Júpiter
Marte conjunción Júpiter
Marte sextil Sol
Marte sextil Mercurio
Marte cuadratura Venus
Marte trígono Quirón
Júpiter conjunción Marte
Júpiter sextil Sol
Júpiter sextil Mercurio
Júpiter cuadratura Venus
Júpiter trígono Quirón
Saturno cuadratura Sol
Saturno cuadratura Mercurio
Saturno sextil Venus
Urano sextil Luna
Urano sextil Nodo Norte
Urano conjunción Selena
Neptuno conjunción Nodo Norte
Neptuno sextil Plutón
Plutón sextil Neptuno
Plutón cuadratura Nodo Norte
Plutón cuadratura Nodo Sur
Nodo Norte conjunción Luna
Nodo Norte conjunción Neptuno
Nodo Norte sextil Urano
Nodo Norte sextil Selena
Nodo Norte cuadratura Plutón
Nodo Sur oposición Nodo Norte
Nodo Sur cuadratura Plutón
Quirón trígono Marte
Quirón trígono Júpiter
Selena conjunción Urano
Selena sextil Luna
Selena sextil Nodo Norte
Lilith conjunción Pholus
Pholus conjunción Lilith
Ceres sextil Pallas
Ceres sextil Vesta
Pallas conjunción Vesta
Pallas sextil Ceres
Juno conjunción Sol
Juno conjunción Mercurio
Vesta conjunción Pallas
Vesta sextil Ceres"""
print(SALIDA)
