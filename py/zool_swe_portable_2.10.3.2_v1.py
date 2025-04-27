#Creado por @nextsigner 2021-2025
#IMPORTANTE!
#Este script requiera la versión 2.0.0.post1
#FUNCIONA EN GNU/LINUX Y WINDOWS
#sudo pip install pyswisseph==2.8.0.post1

#Ejecutar en CMD
#python <este archivo> 13 3 1963 14 0 -3 -32.96 -60.66 T "C:/p1/Zool/zool-release" 0
#python zool_swe_win_2.10.3.2_v1.py 13 3 1963 14 0 -3 -32.96 -60.66 T "C:/p1/Zool/zool-release" 0

#-->Import pyswisseph portable
import os
import sys
import platform

script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, script_dir)

system_name = platform.system()

if system_name == "Windows":
    import pyswisseph_win_2_10_3_2_portable.swisseph as swe
else:
    import pyswisseph_lin_2_10_3_2_portable.swisseph as swe

#<--Import pyswisseph portable

import jdutil
import datetime
from decimal import Decimal
import sys, json
from subprocess import run, PIPE
#from timezonefinder import TimezoneFinder

sys.stdout.reconfigure(encoding='utf-8')

aBodies=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Selena', 57), ('Lilith', 12), ('Pholus', 16), ('Ceres', 17), ('Pallas', 18), ('Juno', 19), ('Vesta', 20)]


def decdeg2dms(dd):
   is_positive = dd >= 0
   dd = abs(dd)
   minutes,seconds = divmod(dd*3600,60)
   degrees,minutes = divmod(minutes,60)
   degrees = degrees if is_positive else -degrees
   return (degrees,minutes,seconds)

#Calculo para Fortuna Diurna Asc + Luna - Sol
#Calculo para Fortuna Nocturna Asc + Sol - Luna


def getIndexSign(grado):
    index=0
    g=0.0
    for num in range(12):
        g = g + 30.00
        if g > float(grado):
            break
        index = index + 1
        #print('index sign: ' + str(num))

    return index

#Para la Conjunción un orbe de 8 grados.
#Para la Oposición un orbe de 8 grados.
#Para el Trígono un orbe de 8 grados.
#Para la Cuadratura, un orbe de 7 grados.
#Para el Sextil, un orbe de 6 grados.
def getAsp(g1, g2, ic):
    asp=-1 # -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono. 3 = conjunción
    #np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Selena', 57), ('Lilith', 12)]
    orbe8=8
    orbe7=7
    if indexAsp == 5 or indexAsp == 6 or indexAsp == 7 or indexAsp == 8 or indexAsp == 9 or indexAsp == 12:
        orbe8=10
        orbe7=9
    #Calculo oposición.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 180.00 + orbe8 and difDeg > 180.00 - orbe8:
        asp=0

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 180.00 + orbe8 and difDeg > 180.00 - orbe8:
        asp=0

    #Calculo cuadratura.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 90.00 + orbe7 and difDeg > 90.00 - orbe7:
        asp=1

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 90.00 + orbe7 and difDeg > 90.00 - orbe7:
        asp=1

    #Calculo trígono.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 120.00 + orbe8 and difDeg > 120.00 - orbe8:
            asp=2

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 240.00 + orbe8 and difDeg > 240.00 - orbe8:
         asp=2

    #Calculo conjunción.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 0 + orbe8 and difDeg > 0 - orbe8:
            asp=3

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 0 + orbe8 and difDeg > 0 - orbe8:
        asp=3

    return asp



def getHouse(gObj, gHouses):
    rh=-1
    for h in range(1,12):
        if(gObj>=gHouses[0][h-1]) and gObj<=gHouses[0][h]:
            #print("Hs: "+str(gHouses))
            #print("H: "+str(h))
            #print("G: "+str(gObj))
            #print("G1: "+str(gHouses[0][h]))
            #print("G2: "+str(gHouses[0][h + 1]))
            rh=h
            break
        #print("G: "+str(g))

    if rh == -1:
        diff=360.00-gHouses[0][0]
        #if gObj>=gHouses[0][0] and gObj<=gHouses[0][11]+diff:
        if gObj>=gHouses[0][11] and gObj<=gHouses[0][0]:
            rh = 12
        else:
            rh = 1

    return rh


dia = sys.argv[1]
mes = int(sys.argv[2]) #+ 1
anio = sys.argv[3]
hora = sys.argv[4]
min = sys.argv[5]
gmt = sys.argv[6]

lat = sys.argv[7]
lon = sys.argv[8]

houseType=sys.argv[9]
#houseType="P"

swePath=sys.argv[10]

alt = sys.argv[11]

GMSLat=decdeg2dms(float(lat))
GMSLon=decdeg2dms(float(lon))



#print('Fecha: '+dia+'/'+mes+'/'+anio+' Hora: '+hora+':'+min)

#Astrolog
#Consulta normal ./astrolog -qa 6 20 1975 23:00 3W 69W57 35S47
#Consultar Aspectos ./astrolog -qa 6 20 1975 23:00 3W 69W57 35S47 -a -A 4

#cmd1='~/astrolog/astrolog -qa '+str(int(mes))+' '+str(int(dia))+' '+anio+' '+hora+':'+min+' ' + str(gmtNum) + ''+ gmtCar +' ' +str(int(GMSLon[0])) + ':' +str(int(GMSLon[1])) + '' + lonCar + ' ' +str(int(GMSLat[0])) + ':' +str(int(GMSLat[1])) + '' + latCar + '  -a -A 4'
#print(cmd1)
#s1 = run(cmd1, shell=True, stdout=PIPE, universal_newlines=True)
#s2=str(s1.stdout).split(sep="\n")

#index=0
#for i in s2:
    #print('------------------>' + str(s2[index]))
    #index= index + 1
    #if index > 15:
        #break

getIndexSign
horaLocal = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))

#Prevo a aplicar el GMT
dia=horaLocal.strftime('%d')
mes=int(horaLocal.strftime('%m'))
anio=horaLocal.strftime('%Y')
hora=horaLocal.strftime('%H')
min=horaLocal.strftime('%M')

stringDateSinGmt= str(dia) + '/' + str(mes) + '/' + str(anio) + ' ' + str(hora) + ':' + str(min)+'"'


d0 = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
jd0 =jdutil.datetime_to_jd(d0)


horaLocal = horaLocal - datetime.timedelta(hours=float(gmt))
#print(horaLocal)

#Luego de aplicar el GMT
dia=horaLocal.strftime('%d')
mes=int(horaLocal.strftime('%m'))
anio=horaLocal.strftime('%Y')
hora=horaLocal.strftime('%H')
min=horaLocal.strftime('%M')

#print('Tiempo: ' + dia + '/' + mes + '/' + anio + ' ' + hora + ':' + min)


swe.set_ephe_path(swePath+'/swe')

latitud = float(lat)
longitud = float(lon)
altura = float(alt)
swe.set_topo(latitud, longitud, altura)

#swe.set_ephe_path('./swe')
#swe.set_ephe_path('/usr/share/libswe/ephe')

d = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
jd1 =jdutil.datetime_to_jd(d)

jsonParams='"params":{'
jsonParams+='"jd":'+str(jd1)+','
jsonParams+='"sd": "'+ str(dia) + '/' + str(mes) + '/' + str(anio) + ' ' + str(hora) + ':' + str(min)+'",'
jsonParams+='"sdgmt": "'+ stringDateSinGmt+','
jsonParams+='"hsys": "' + str(houseType) + '",'
jsonParams+='"d": '+ str(sys.argv[1]) +','
jsonParams+='"m": '+ str(sys.argv[2]) +','
jsonParams+='"a": '+ str(sys.argv[3]) +','
jsonParams+='"h": '+ str(sys.argv[4]) +','
jsonParams+='"min": '+ str(sys.argv[5]) +','
jsonParams+='"gmt": '+ str(sys.argv[6]) +','
jsonParams+='"lat": '+ str(sys.argv[7]) +','
jsonParams+='"lon": '+ str(sys.argv[8]) +','
jsonParams+='"alt": '+ str(sys.argv[11]) +''
jsonParams+='}'

#sys.argv[11]


j={}
j["params"]={}
j["params"]["jd"]=str(jd1)
j["params"]["jd"]=jd1
j["params"]["sdgmt"]=str(dia) + '/' + str(mes) + '/' + str(anio) + ' ' + str(hora) + ':' + str(min)
j["params"]["hsys"]=houseType
#La oblicuidad de calcula con ipl = SE_ECL_NUT = -1 en SWE pero en swisseph ECL_NUT = -1
#posObli=swe.calc(jd1, -1, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
#posObli=swe.calc(jd1, swe.ECL_NUT, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
posObli=swe.calc(jd0, swe.ECL_NUT)
oblicuidad=posObli[0][0]
#print('Oblicuidad: ' + str(posObli[0][0]))

#Se calculan casas previamente para calcular en cada cuerpo con swe.house_pos(...)
h=swe.houses(jd1, float(lat), float(lon), bytes(houseType, encoding = "utf-8"))
#print(h)
#swe.set_topo(float(lat), float(lon), 1440.00)
#h=swe.houses(jd1, float(lat), float(lon), bytes(houseType, encoding = "utf-8"))

jsonString='{'

#Comienza JSON Bodies
tuplaPosBodies=()
jsonBodies='"pc":{'
j["pc"]={}
index=0
for i in aBodies:
    #pos=swe.calc_ut(jd1, aBodies[index][1], flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
    pos=swe.calc_ut(jd1, aBodies[index][1])
    #print(pos)
    gObj=float(pos[0][0])
    if index == 11:
        #posNN=swe.calc_ut(jd1, aBodies[10][1], flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
        gNN=float(tuplaPosBodies[index - 1])#float(posNN[0][0]) + 180 #
        if gNN < 180:
            gNS= 180.00 + gNN#360.00 - gNN
        else:
            gNS=gNN - 180.00

        #print('Planeta: ' +aBodies[index][0] + ' casa ' + str(posHouse))
        #print('Grado de Nodo Norte: '+str(gNN))
        #print('Grado de Nodo Sur: '+str(gNS))
        gObj=gNS

    tuplaPosBodies+=tuple([gObj])
    indexSign=getIndexSign(gObj)
    td=decdeg2dms(gObj)
    gdeg=int(td[0])
    mdeg=int(td[1])
    sdeg=int(td[2])
    rsgdeg=gdeg - ( indexSign * 30 )
    jsonBodies+='"c' + str(index) +'": {' if (index==0) else  ',"c' + str(index) +'": {'
    jsonBodies+='"nom":"' + str(aBodies[index][0]) + '",'
    jsonBodies+='"is":' + str(indexSign)+', '
    jsonBodies+='"gdec":' + str(gObj)+', '
    jsonBodies+='"gdeg":' + str(gdeg)+', '
    jsonBodies+='"rsgdeg":' + str(rsgdeg)+', '
    jsonBodies+='"mdeg":' + str(mdeg)+', '
    jsonBodies+='"sdeg":' + str(sdeg)+', '
    j["pc"]["c"+str(index)]={}
    j["pc"]["c"+str(index)]["nom"]=str(aBodies[index][0])
    j["pc"]["c"+str(index)]["is"]=indexSign
    j["pc"]["c"+str(index)]["gdec"]="%.2f" % gObj
    j["pc"]["c"+str(index)]["gdeg"]="%.2f" % gdeg
    j["pc"]["c"+str(index)]["rsgdeg"]="%.2f" % rsgdeg
    j["pc"]["c"+str(index)]["mdeg"]="%.2f" % mdeg
    j["pc"]["c"+str(index)]["sdeg"]="%.2f" % sdeg
    #posHouse=swe.house_pos(h[0][9],float(lat), oblicuidad, gObj, 0.0, bytes(houseType, encoding = "utf-8"))



    #Probando con ARMC h[1][2]
    #np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Selena', 57), ('Lilith', 12)]
    retro=-1
    if index == 0:#Sol
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        #":Args: float armc, float geolat, float eps, seq objcoord,"
        #" bytes hsys=b'P'\n\n"
        #" - armc: ARMC\n"
        #" - geolat: geographic latitude, in degrees (northern positive)\n"
        #" - eps: obliquity, in degrees\n"
        #" - objcoord: a sequence for ecl. longitude and latitude of the planet,\n"
        #"   in degrees\n"
        #" - hsys: house method identifier (1 byte)\n\n"
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))


        #posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, calcs[0][0], calcs[0][1], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 1:#Luna
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 2:#Mercurio
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 3:#Venus
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 4:#Marte
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 5:#Júpiter
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 6:#Saturno controlar que está °1 atrasado
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 7:#Urano
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 8:#Neptuno
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
    elif index == 9:#Plutón controlar que está °1 atrasado
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        #calcs = swe.calc_ut(jd1, aBodies[index][1], flag=swe.FLG_SWIEPH)
        #posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, calcs[0][0], calcs[0][1], bytes(houseType, encoding = "utf-8"))
        #posHouse=int(posHouse)
        #print("p1:"+str(posHouse))
        #posHouse = posHouse % 1.0
        #print("p2:"+str(posHouse))
        posHouseRev=getHouse(pos[0][0],h)
        if posHouse != posHouseRev:
            posHouse=posHouseRev
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 10:#Nodo Norte
        #calcs = swe.calc_ut(jd1, aBodies[index][1], flag=swe.TRUE_NODE)
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 11:#Nodo Sur
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0] -181.00, calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 12:#Quirón
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
    elif index == 13:#Selena
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        if pos[0][3] < 0:
            retro=0
        else:
            retro=1
    elif index == 14:#Lilith
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
    else:
        calcs = swe.calc_ut(jd1, aBodies[index][1])
        posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, [calcs[0][0], calcs[0][1]], bytes(houseType, encoding = "utf-8"))
        #print(calcs)

    #hom = swisseph.house_pos(asmc[2], observer.lat, obliquity, calcs[0], objlat=calcs[1])
    #Args: float armc, float geolat, float obliquity, float objlon, float objlat=0.0, char hsys='P'
    #posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, calcs[0][0], calcs[0][1], bytes(houseType, encoding = "utf-8"))
    #posHouse=swe.house_pos(h[1][2],float(lat), oblicuidad, pos[0][0], pos[0][1], bytes(houseType, encoding = "utf-8"))

    #Funciona bien
    #posHouse=getHouse(gObj, h)


    jsonBodies+='"ih":' + str(int(posHouse))+', '
    jsonBodies+='"dh":' + str(posHouse)+', '
    jsonBodies+='"retro":' + str(retro)
    jsonBodies+='}'
    j["pc"]["c"+str(index)]["ih"]=int(posHouse)
    j["pc"]["c"+str(index)]["dh"]="%.2f" %  posHouse
    j["pc"]["c"+str(index)]["retro"]=retro
    index=index + 1

jsonBodies+='}'


jsonAspets='"asps":{'
j["asps"]={}
#print(tuplaPosBodies)
tuplaArr=(())
#arr1=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
#arr2=(0,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
#arr3=(0,1,3,4,5,6,7,8,9,10,11,12,13,14,15)
#arr4=(0,1,2,4,5,6,7,8,9,10,11,12,13,14,15)
#arr5=(0,1,2,3,5,6,7,8,9,10,11,12,13,14,15)
#arr6=(0,1,2,3,4,6,7,8,9,10,11,12,13,14,15)
#arr7=(0,1,2,3,4,5,7,8,9,10,11,12,13,14,15)
#arr8=(0,1,2,3,4,5,6,8,9,10,11,12,13,14,15)
#arr9=(0,1,2,3,4,5,6,7,9,10,11,12,13,14,15)
#arr10=(0,1,2,3,4,5,6,7,8,10,11,12,13,14,15)
#arr11=(0,1,2,3,4,5,6,7,8,9,11,12,13,14,15)
#arr12=(0,1,2,3,4,5,6,7,8,9,10,12,13,14,15)
#arr13=(0,1,2,3,4,5,6,7,8,9,10,11,13,14,15)
#arr14=(0,1,2,3,4,5,6,7,8,9,10,11,12,14,15)
#arr15=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,15)
#arr16=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14)
arr1=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr2=(0,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr3=(0,1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr4=(0,1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr5=(0,1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr6=(0,1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr7=(0,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr8=(0,1,2,3,4,5,6,8,9,10,11,12,13,14,15,16,17,18,19,20)
arr9=(0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20)
arr10=(0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20)
arr11=(0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20)
arr12=(0,1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20)
arr13=(0,1,2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,19,20)
arr14=(0,1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20)
arr15=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,17,18,19,20)
arr16=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,17,18,19,20)
arr17=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20)
arr18=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20)
arr19=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20)
arr20=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20)
arr21=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)
#tuplaArr=((arr1),(arr2),(arr3),(arr4),(arr5),(arr6),(arr7),(arr8),(arr9),(arr10),(arr11),(arr12),(arr13),(arr14),(arr15),(arr16))
tuplaArr=((arr1),(arr2),(arr3),(arr4),(arr5),(arr6),(arr7),(arr8),(arr9),(arr10),(arr11),(arr12),(arr13),(arr14),(arr15),(arr16),(arr17),(arr18),(arr19),(arr20),(arr21))

#print(tuplaArr)
index=0
indexAsp=0
for i in tuplaPosBodies:
    #print('i:' + str(i))
    #for num in range(14):
    for num in range(19):
        #print('Comp: ' + str(aBodies[index][0]) + ' con ' + str(aBodies[tuplaArr[index][num]][0]))
        g1=float(tuplaPosBodies[index])
        g2=float(tuplaPosBodies[tuplaArr[index][num]])
        #print('g1: '+str(g1) + ' g2: ' + str(g2))
        controlar=str(tuplaArr[index][num])==str(index)

        asp=getAsp(g1, g2, index)
        stringInvertido='"ic1":' + str(tuplaArr[index][num]) + ', "ic2":' + str(index) + ', '
        stringActual='"ic1":' + str(index) + ', "ic2":' + str(tuplaArr[index][num]) + ', '
        stringOpNodNorNodSur='"ic1":11, "ic2":10"'
        stringOpNodSurNodNor='"ic1":10, "ic2":11"'
        opNodos=False
        if (index == 10 and int(tuplaArr[index][num]) == 10) or (index == 11 and int(tuplaArr[index][num]) == 11) or (index == 10 and int(tuplaArr[index][num] == 10)) or (index == 11 and int(tuplaArr[index][num]) == 10):
            opNodos=True
        #if opNodos == True:
            #print(stringInvertido)
            #print(stringActual)
        #opNodos=False
        #if asp >= 0 and stringInvertido not in jsonAspets and controlar == False and opNodos == False:
        if asp >= 0 and controlar == False and opNodos == False and str(aBodies[index][0]) != str(aBodies[num][0]):
            jsonAspets+='"asp' +str(indexAsp) + '": {' if (indexAsp==0) else  ',"asp' +str(indexAsp) + '": {'
            #jsonAspets+='"asp' +str(index) + '": {'
            jsonAspets+=stringActual
            jsonAspets+='"c1":"' + str(aBodies[index][0]) + '", '
            jsonAspets+='"c2":"' + str(aBodies[num][0]) + '", '
            jsonAspets+='"ia":' + str(asp) + ','
            jsonAspets+='"gdeg1":' + str(g1) + ','
            jsonAspets+='"gdeg2":' + str(g2) + ','
            jsonAspets+='"dga":' + str(swe.difdegn(g1, g2)) + ''
            jsonAspets+='}'
            j["asps"]["asp"+str(indexAsp)]={}
            j["asps"]["asp"+str(indexAsp)]["c1"]=str(aBodies[index][0])
            j["asps"]["asp"+str(indexAsp)]["c2"]=str(aBodies[num][0])
            j["asps"]["asp"+str(indexAsp)]["ia"]=asp
            j["asps"]["asp"+str(indexAsp)]["gdeg1"]="%.2f" % g1
            j["asps"]["asp"+str(indexAsp)]["gdeg2"]="%.2f" % g2
            j["asps"]["asp"+str(indexAsp)]["dgq"]="%.2f" % swe.difdegn(g1, g2)
            indexAsp = indexAsp +1
        #print('Dif 1: '+str(swe.difdegn(g1, g2)))
        #print('Dif 2: '+str(swe.difdegn(g2, g1)))
        #print(asp)
        #print('Comp:' + aBodies[index][0] + ' con '
    index = index + 1

jsonAspets+='}'
#print(jsonAspets)
#print('Cantidad de Aspectos: '+str(indexAsp))
#Comienza JSON Houses
jsonHouses='"ph":{'
j["ph"]={}
numHouse=0
#print('ARMC:' + str(h[1][2]))

for i in h[0]:
    td=decdeg2dms(i)
    gdeg=int(td[0])
    mdeg=int(td[1])
    sdeg=int(td[2])
    index=getIndexSign(float(i))
    rsgdeg=gdeg - ( index * 30 )
    jsonHouses+='"h' + str(int(numHouse + 1)) + '": {'
    jsonHouses+='"is":' + str(index)+', '
    jsonHouses+='"gdec":' + str(i)+','
    jsonHouses+='"rsgdeg":' + str(rsgdeg)+', '
    jsonHouses+='"gdeg":' + str(gdeg)+','
    jsonHouses+='"mdeg":' + str(mdeg)+','
    jsonHouses+='"sdeg":' + str(sdeg)+''
    if numHouse != 11:
        jsonHouses+='},'
    else:
        jsonHouses+='}'
    numHouse = numHouse + 1
    j["ph"]["h"+str(numHouse)]={}
    j["ph"]["h"+str(numHouse)]["is"]=index
    j["ph"]["h"+str(numHouse)]["gdec"]="%.2f" % int(i)
    j["ph"]["h"+str(numHouse)]["rsgdeg"]="%.2f" % rsgdeg
    j["ph"]["h"+str(numHouse)]["gdeg"]="%.2f" % gdeg
    j["ph"]["h"+str(numHouse)]["mdeg"]="%.2f" % mdeg
    j["ph"]["h"+str(numHouse)]["sdeg"]="%.2f" % sdeg
jsonHouses+='}'

jsonString+='' + jsonBodies + ','
jsonString+='' + jsonHouses + ','
jsonString+='' + jsonAspets + ','
jsonString+='' + jsonParams
jsonString+='}'

#print(jsonBodies)
#print(jsonHouses)
#print(jsonAspets)

#Imprime el JSON
print(jsonString)

#print(str(j).replace('\'', '\"'))
#resJson=json.dumps(j, indent=4, sort_keys=False, ensure_ascii=False)
#resJson = resJson.decode("unicode_escape")
#print(resJson)
#getinfo(0.0, 0.0, 1970, 1, 1, 0.0, bytes("P", encoding = "utf-8"), display=range(23))
#getinfo(jd1)
#print(get)
#print(getHouse(114.323, h))
#for num in range(100):
    #print('Nombre: '+swe.get_planet_name(num)+' Num: '+str(num))
swe.close()

#help(swe)
#import pydoc
#help_text = pydoc.render_doc(swe)
#print(help_text)
