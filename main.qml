import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import FileMaker 1.0

import Qt.labs.settings 1.0

ApplicationWindow{
    id: app
    visible: true
    visibility: 'Maximized'
    color: c1


    property bool dev: false
    property string sweBodiesPythonFile: 'zool_swe_portable_2.10.3.2_v1.py'

    property int fs: Screen.width*0.02
    property color c1: 'black'
    property color c2: 'white'

    property string cNom: ''
    property var uParams
    property var uFullParams
    property string uBodiesDataList: ''
    property var uArrayBodiesTitList: []
    property string uAspsData: ''

    property var aSigns: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property var aSignsLowerStyle: ['aries', 'tauro', 'geminis', 'cancer', 'leo', 'virgo', 'libra', 'escorpio', 'sagitario', 'capricornio', 'acuario', 'piscis']
    property var aBodies: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Norte', 'N.Sur', 'Quirón', 'Selena', 'Lilith', 'Pholus', 'Ceres', 'Pallas', 'Juno', 'Vesta']

    onUAspsDataChanged: {
        if(uAspsData!==''){
            ta1.text+='Consultando sobre la casa 6.\n'
            console.log('uAspsData: '+uAspsData)
            //mkHouseRequest(getConsHouse(6), 6)
        }
    }

    Settings{
        id: apps
        fileName: 'astromaker.cfg'
        property bool enableDev: false
        property bool enableAutoCons: false
        property string uFilePath
        property string gitHubHtmlRepUrl: '/home/ns/nsp/zool-html-files'
        property color backgroundColor: 'black'
        property color fontColor: 'white'
        property bool desTec: false
        property bool sendPurpose: false
    }

    Column{
        Row{
            Rectangle{
                width: app.width/3
                height: app.height-xCtrls.height
                color: 'transparent'
                border.width: 2
                border.color: app.c2
                clip: true
                FileMaker{id: fileMaker}
            }
            Rectangle{
                width: app.width/3
                height: app.height-xCtrls.height
                color: 'transparent'
                border.width: 2
                border.color: app.c2
                clip: true
                ListView{
                    id: lv
                    model: lm
                    delegate: compLvItem
                    opacity: tCheck.running?1.0:0.5
                    anchors.fill: parent
                    ListModel{
                        id: lm
                        function addItem(json, tipo, estado){
                            return {
                                j: json,
                                t: tipo,
                                e: estado
                            }
                        }
                    }
                    Component{
                        id: compLvItem
                        Rectangle{
                            width: parent.width
                            height: txt1.contentHeight+app.fs*0.5
                            color: 'transparent'
                            Rectangle{
                                anchors.fill: parent
                                color: e===0?app.c1:(e===1?'red':'green')
                                onColorChanged: {
                                    if(color==='red')lv.currentIndex=index
                                }
                                border.width: 1
                                border.color: app.c2
                                radius: app.fs*0.1
                                //visible:
                            }
                            Text{
                                id: txt1
                                width: parent.width-app.fs*0.5
                                font.pixelSize: app.fs*0.5
                                color: app.c2
                                wrapMode: Text.WordWrap
                                anchors.centerIn: parent
                            }

                            Component.onCompleted: {
                                if(!j.house){
                                    let str=t===1?'<b>Pos: </b>':'<b>Neg: </b>'
                                    let b=j.nom
                                    let s=app.aSigns[j.is]
                                    let h=j.ih
                                    let deg=j.gdec
                                    str+=b+' en '+s+' en Casa '+h
                                    txt1.text='<b>'+parseInt(index+1)+'</b> '+str
                                }else{
                                    txt1.text='<b>'+parseInt(index+1)+'</b> Casa '+j.house//+' e:'+e
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                width: app.width/3
                height: app.height-xCtrls.height
                color: 'transparent'
                border.width: 2
                border.color: app.c2
                clip: true
                Flickable{
                    id: flk1
                    contentWidth: parent.width
                    contentHeight: ta1.contentHeight+app.fs*3
                    anchors.fill: parent
                    TextArea{
                        id: ta1
                        width: parent.width
                        height: contentHeight+app.fs
                        color: app.c2
                        font.pixelSize: app.fs*0.5
                        wrapMode: TextArea.WordWrap
                        onTextChanged: flk1.contentY=flk1.contentHeight-flk1.height
                    }
                }
            }
        }
        Rectangle{
            id: xCtrls
            width: parent.width
            height: app.fs*1.5
            color: 'transparent'
            border.width: 1
            border.color: 'white'
            Row{
                spacing: app.fs*0.5
                anchors.centerIn: parent
                Rectangle{
                    width: parent.spacing*2
                    height: width
                    radius: width*0.5
                    color: tCheck.running?'green':'red'
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            tCheck.running=!tCheck.running
                        }
                    }
                }
                Row{
                    spacing: app.fs*0.1
                    anchors.verticalCenter: parent.verticalCenter
                    Text{
                        text: 'Describir Aspectos'
                        font.pixelSize: app.fs*0.5
                        color: app.c2
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    CheckBox{
                        checked: apps.desTec
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckedChanged: apps.desTec=checked
                    }
                }
                Row{
                    spacing: app.fs*0.1
                    anchors.verticalCenter: parent.verticalCenter
                    Text{
                        text: 'Avisar en Purpose'
                        font.pixelSize: app.fs*0.5
                        color: app.c2
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    CheckBox{
                        checked: apps.sendPurpose
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckedChanged: apps.sendPurpose=checked
                    }
                }
                Button {
                    id: setAutoCons
                    text: apps.enableAutoCons?"Desactivar":"Activar"
                    font.pixelSize: app.fs*0.35
                    onClicked: {
                        apps.enableAutoCons=!apps.enableAutoCons
                        tCheck.running=apps.enableAutoCons
                        if(apps.enableAutoCons)init()
                    }
                }
                Button {
                    id: openFileButton
                    text: "Abrir Archivo"
                    font.pixelSize: app.fs*0.35
                    onClicked: fileDialog.visible = true
                }
                Button {
                    id: btnReload
                    text: "Recargar"
                    font.pixelSize: app.fs*0.35
                    onClicked: init()
                }
                Button {
                    id: btnDeleteAll
                    text: "Borrar Todo"
                    font.pixelSize: app.fs*0.35
                    onClicked: deleteAll()
                }
                Button {
                    id: botEnableDev
                    text: apps.enableDev?"D-Dev":"H-Dev"
                    font.pixelSize: app.fs*0.35
                    visible: app.dev
                    onClicked: apps.enableDev=!apps.enableDev
                }
            }
        }
    }

    Timer{
        id: tCheck
        running: false
        repeat: true
        interval: apps.enableDev?1000:3000
        onTriggered: {
            if(apps.uFilePath===''){
                ta1.text='No hay ningún archivo para revisar.'
                return
            }
            check()
        }
    }

    Component.onCompleted: {
        if(unik.folderExist('/home/ns/nsp')){
            app.dev=true
            ta1.text='MODO DEV\n'
        }
        ta1.text+='Último archivo procesado: '+apps.uFilePath
        init()
        //        let f=apps.uFilePath
        //        if(!unik.fileExist(f)){
        //            ta1.text='No hay ningún archivo para procesar.'
        //            ta1.text+='Último archivo creado: '+apps.uFilePath
        //            return
        //        }
        //        loadFile(apps.uFilePath)
    }
    FileDialog {
        id: fileDialog
        title: "Seleccionar archivo"
        nameFilters: ["Archivos JSON (*.json)"]
        selectExisting: true
        onVisibilityChanged: {
            if(visible)tCheck.stop()
        }
        onAccepted: {
            if (fileDialog.fileUrl.toString()) {
                ta1.text+="Archivo seleccionado:"+fileDialog.fileUrl
                apps.uFilePath=(''+fileDialog.fileUrl).replace('file://', '')
                app.loadFile(apps.uFilePath)
            }
        }
        onRejected: {
            console.log("Selección de archivo cancelada")
        }
    }

    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Ctrl+Space'
        onActivated: {
            tCheck.running=!tCheck.running
        }
    }
    Shortcut{
        sequence: 'Ctrl+f'
        onActivated: {
            ta1.text+=getFileList().toString()
        }
    }
    function init(){
        if(!apps.enableAutoCons)return
        let f=apps.uFilePath
        if(!unik.fileExist(f)){
            ta1.text='No hay ningún archivo para procesar.\n'
            ta1.text+='Último archivo creado: '+apps.uFilePath+'\n'
            return
        }
        loadFile(apps.uFilePath)
    }
    function loadFile(url){
        if(!unik.fileExist(url))return
        let fd1=unik.getFile(url).replace(/\n/g, '')
        let j1=JSON.parse(fd1)
        app.uParams=j1.params
        app.cNom=j1.params.n
        unik.mkdir(unik.getPath(3)+'/astromaker')
        let jd=unik.getFile(url)
        let j=JSON.parse(jd)
        mkAnRunSweRequest(j)
    }
    function loadJson(jsonString){
        lm.clear()
        app.uBodiesDataList=''
        app.uArrayBodiesTitList=[]
        let json=JSON.parse(jsonString.replace(/\n/g, ''))
        app.uFullParams=json
        let indexId=15
        for(var i=0;i<Object.keys(json.pc).length;i++){
            let jbodie=json.pc['c'+i]
            lm.append(lm.addItem(jbodie, 1, 0))
            lm.append(lm.addItem(jbodie, 0, 0))
            app.uBodiesDataList+=jbodie.nom+' en '+app.aSigns[jbodie.is]+' en casa '+jbodie.ih+',\n'
            app.uArrayBodiesTitList.push('<h3 id="'+indexId+'">'+jbodie.nom+' en '+app.aSigns[jbodie.is]+' en casa '+jbodie.ih+'<h3>')
            indexId++
        }
        let j={}
        for(i=1;i<=12;i++){
            j.house=i
            lm.append(lm.addItem(j, 0, 0))
        }

        //tCheck.start()
        let filePathAsps=unik.getPath(3)+'/astromaker/'+app.cNom+'/asps.html'
        if(unik.fileExist(filePathAsps)){
            app.uAspsData=unik.getFile(filePathAsps)
        }else{
            mkAspsRequest()
        }
    }

    function check(){
        if(!apps.enableAutoCons)return
        if(app.uAspsData==='')return
        let indexForRequest=-1
        let filePathForRequest=''
        let hayTareas=false

        let consultarHouses=false
        let consultarHousesNum=-1


        let folder=unik.getPath(3)+'/astromaker/'+app.cNom
        for(var i=0;i<lm.count;i++){
            let e=lm.get(i).e
            if(e===1)return
            let t=lm.get(i).t===1?'pos':'neg'
            let j=lm.get(i).j
            if(!unik.folderExist(folder)){
                unik.mkdir(folder)
            }
            //ta1.text+='j: '+JSON.stringify(j, null, 2)
            if(!j.house){
                let b=j.nom
                let s=app.aSigns[j.is]
                let h=j.ih
                let fileName=t+'_'+b+'_'+s+'_'+h+'.html'
                let filePath=folder+'/'+fileName
                filePathForRequest=filePath
                if(!unik.fileExist(filePath)){
                    //ta1.text+=filePath+' no existe.\n\n'
                    indexForRequest=i
                    hayTareas=true
                    break
                }else{
                    //ta1.text+=filePath+' ya existe.\n\n'
                    lm.setProperty(i, "e", 2)
                }
            }else{
                ta1.text+='\nSe procesa casa '+j.house+'\n'
                let fileName='inter_house_'+j.house+'.html'
                let filePath=folder+'/'+fileName
                filePathForRequest=filePath
                if(!unik.fileExist(filePath)){
                    //ta1.text+=filePath+' no existe.\n\n'
                    indexForRequest=i
                    consultarHouses=true
                    consultarHousesNum=j.house
                    hayTareas=true
                    break
                }else{
                    //ta1.text+=filePath+' ya existe.\n\n'
                    lm.setProperty(i, "e", 2)
                }
            }
        }
        if(indexForRequest>=0){
            lm.setProperty(indexForRequest, "e", 1)
            if(!consultarHouses){
                mkAIRequest(prepareRequest(indexForRequest), filePathForRequest, indexForRequest)
            }else{
                mkAIRequest(getConsHouse(consultarHousesNum), filePathForRequest, indexForRequest)
            }
            lv.currentIndex=indexForRequest
            //ta1.text+='Consultando: '+prepareRequest(indexForRequest)+'.\n\n'
            //ta1.text+='\n\n'+getAspCons()
        }
        if(!hayTareas){
            ta1.text+='Aviso: No hay más tareas para realizar.\n\n'
            //ta1.text+=getAspCons()
            tCheck.stop()
            let headData=getHtmlHead()
            //ta1.text+=headData
            unik.setFile(folder+'/head.html', headData)
            unik.setFile(folder+'/indice.html', getHtmlIndice())
            let footData=''
            footData+='<br><hr><br><h4>Creado por Ricardo Martín Pizarro - 2025</h4><h4>Whatsapp +54 9 1138024370</h4><hr><br>'
            footData+='</body></html>'
            unik.setFile(folder+'/foot.html', footData)
            mkAllFilesToOne()
            if(apps.sendPurpose)sendMessage('Se terminó de crear la carta de '+app.cNom)
        }
    }
    function prepareRequest(index){
        if(!tCheck.running)return ''
        let cons='Por favor, genera el siguiente contenido estrictamente en formato HTML, sin incluir ningún texto o comentario adicional antes o después de la respuesta HTML. Por favor, genera únicamente el código HTML para una lista desordenada (<ul>) con los siguientes elementos como ítems de lista (<li>), sin incluir las etiquetas <html>, <head>, <body> ni ningún otro texto o comentario adicional antes o después del código solicitado. '
        let t=lm.get(index).t
        let strManPosONeg=''
        if(t===1){
            strManPosONeg='positiva'
        }else{
            strManPosONeg='negativa'
        }
        let j=lm.get(index).j
        let b=j.nom
        let s=app.aSigns[j.is]
        let h=j.ih
        cons+='Consulta sobre Astrología. Dime cómo se manifiestan en el plano astrológico, en este caso de manera '+strManPosONeg+', es decir, quiero que en tu respuesta me digas al menos 10 manifestaciones '+strManPosONeg+'s de '+b+' en el signo '+s+' en Casa '+h+'. El formato de tu respuesta debe ser la siguiente; En formato HTML, en 10 párrafos, que cada párrafo comience con el tipo de manifestación en negrita con 2 puntos, a modo de título introductorio y 2 o 3 oraciones explicándo la manifestación en cuentión. El listado de manifestaciones debe estar en el contexto de una lista HTML. Solo incluye los tags html de la lista porque tu respuesta se incluirá dentro de un html globar que ya tendrá los tags html, head, title y body. No quiero explicación extra al inicio ni al pié. Explícaselo a una persona llamada '+app.cNom.replace(/_/g, '_')+' en segunda persona. No es necesario que utilices su nombre completo. Preferentemente utiliza su primer nombre. No es necesario que en la lista enumeres con un número entero, por ejemplo 1., 2., 3. en cambio debes decorar cada item de la lista con el punto redondo.  No incluyas datos o información por fuera o extra a las 2 listas de manifestaciones positivas y negativas.'
        return cons
    }
    function mkAIRequest(cons, filePath, itemIndex){
        if(!tCheck.running)return
        let d=new Date(Date.now())
        let ms=d.getTime()
        let c=''
        c+='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='Item{\n'
        c+='    id: item'+ms+'\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        unik.setFile(\''+filePath+'\', logData)\n'
        //c+='        ta1.text+=logData\n\n'
        c+='        ta1.text+=\'\\nSe ha procesado la consulta '+parseInt(itemIndex+1)+'/\'+lm.count\n\n'
        //c+='        ta1.text+="\n"+getAspCons()\n\n'
        c+='        lm.setProperty('+itemIndex+', "e", 2)\n'
        c+='        item'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='}\n'
        c+='    Component.onCompleted: {\n'
        if(apps.enableDev){
            c+='        uqp'+ms+'.run(\'python3 ./ds_dev.py "'+cons+'"\')\n'
        }else{
            c+='        uqp'+ms+'.run(\'python3 ./ds.py "'+cons+'"\')\n'
        }
        c+='    }\n'
        c+='}\n'
        let obj=Qt.createQmlObject(c, app, 'uqpiarequestcode')
    }
    function mkAnRunSweRequest(j){
        let vd=j.params.d
        let vm=j.params.m
        let va=j.params.a
        let vh=j.params.h
        let vmin=j.params.min
        let vgmt=j.params.gmt
        let vlon=j.params.lon
        let vlat=j.params.lat
        let valt=j.params.alt

        let d = new Date(Date.now())
        let ms=d.getTime()
        let hsys=j.params.hsys?j.params.hsys:'T'
        if(j.params.hsys)hsys=j.params.hsys
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        //c+='        let json=(\'\'+logData)\n'
        c+='        //log.lv(\'JSON: \'+json)\n'
        //c+='        ta1.text+=json\n'
        c+='            loadJson(logData)\n'
        c+='        uqp'+ms+'.destroy(3000)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        console.log(\'zm.load() python3 "'+unik.currentFolderPath()+'/py/'+app.sweBodiesPythonFile+'" '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+' '+hsys+' '+unik.currentFolderPath()+' '+valt+'\')\n'
        c+='        run(\'python3 "'+unik.currentFolderPath()+'/py/'+app.sweBodiesPythonFile+'" '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+' '+hsys+' "'+unik.currentFolderPath()+'" '+valt+'\')\n'
        //c+='        Qt.quit()\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, app, 'uqpswecode')
    }
    function getFileList(){
        let aFileList=[]
        let folder=unik.getPath(3)+'/astromaker/'+app.cNom
        aFileList.push(folder+'/head.html')
        aFileList.push(folder+'/indice.html')


        let numHouse=-1
        let fileName
        let filePath
        for(var i=1;i<=12;i++){
            numHouse=i
            fileName='inter_house_'+numHouse+'.html'
            filePath=folder+'/'+fileName
            aFileList.push(filePath)
        }

        for(i=0;i<lm.count-12;i++){
            let j=lm.get(i).j
            //ta1.text+='\n\n'+JSON.stringify(j, null, 2)+'\n'
            let b=j.nom
            let s=app.aSigns[j.is]
            let h=j.ih
            //ta1.text+='b: '+b+'\n'
            //ta1.text+='s: '+s+'\n'
            //ta1.text+='h: '+h+'\n\n'
            filePath=''

            let t=lm.get(i).t
            fileName=''
            if(t===1){
                fileName='pos_'+b+'_'+s+'_'+h+'.html'
                filePath=folder+'/'+fileName
            }else{
                fileName='neg_'+b+'_'+s+'_'+h+'.html'
                filePath=folder+'/'+fileName
            }
            ta1.text+='fp: '+filePath+'\n'
            aFileList.push(filePath)
        }
        aFileList.push(folder+'/foot.html')
        return aFileList
    }
    function getHtmlIndice(){
        let a = getArrayTits()
        var s=''
        s+='\n<h2 id="0">Índice</h2>'
        s+='<h3>Las 12 Casas Astrológicas</h3>\n'
        s+='<p><b>Nota: </b>Este índice te permite ir a conocer las interpretaciones astrológicas casa por casa para conocer de qué modo se manifestarán los astros en cada área de tu vida como ser trabajo, relaciones, economía, infancia y diferentes partes de tu personalidad y de tu vida en general.</p>\n'
        s+='<ul>'
        for(var i=2;i<12+2;i++){
            s+='<li><a href="#'+parseInt(i)+'" style="color: #ff8833;"><b>Casa '+parseInt(i-1)+':</b></a> <p>'+htmlToText(a[i])+'</p></li>\n'
        }
        s+='</ul>\n'

        s+='<hr>\n'

        s+='<h2>Los planetas y cuerpos astrológicos</h2>\n'
        s+='<p><b>Nota: </b>Este índice te permite ir a conocer las interpretaciones astrológicas de cada planeta o cuerpo en cada signo y casa.</p>\n'

        s+='<ul>\n'

        let posWrited=false
        let indexNoRepeat=0;
        for(i=0;i<lm.count-12;i++){
            if(!posWrited){
                let j=lm.get(i).j
                let b=j.nom
                let sign=app.aSigns[j.is]
                let h=j.ih
                s+='<li><a href="#'+parseInt(indexNoRepeat+14+1)+'" style="color: #ff8833;">'+b+' '+sign+' en Casa '+h+'</a></li><br>\n'
                posWrited=true
                indexNoRepeat++
                continue
            }
            posWrited=false
        }
        s+='</ul>\n'
        return s
    }
    function getArrayHtmlTits(){
        let a = getArrayTits()

        for(var i=0;i<app.uArrayBodiesTitList.length;i++){
            a.push(app.uArrayBodiesTitList[i]+'<h4>Manifestaciones Positivas</h4>')
            a.push('<h4>Manifestaciones Negativas</h4>')
        }
        a.push("<!-- Tit Foot -->")
        let ac=a
        a=[]
        for(i=0;i<ac.length;i++){
            a.push(ac[i].replace(/,/g, '@'))
        }

        return a
    }
    function getArrayTits(){
        let a=[]
        a.push('<!-- Tit Head -->')
        a.push('<!-- Tit indice -->')
        a.push('<h3 id="2">Personalidad e impresión hacia los demás</h3>')
        a.push('<h3 id="3">Capacidad de Materializar, recursos, economía, interacción con la naturaleza, belleza y disfrute de la vida</h3>')
        a.push('<h3 id="4">Maneras de expresarse, dialogar, comunicarse, tipo de entorno cercano y modos de ralcionarse, moverse o interactual con el</h3>')
        a.push('<h3 id="5">Tipo de hogar en el que habitas, nido donde te criaste en la infancia, recuerdos y relación con el pasado, la familia, la madre, abuelos o tipos de emociones</h3>')
        a.push('<h3 id="6">Asuntos relacionados con el ego, el auto estima, la identidad, la expresividad, la creatividad, los hijos, el juego, los tipos de romances, las maneras de brillar o ponerse en el centro de la escena</h3>')
        a.push('<h3 id="7">Ámbito laboral, rutinas y salud</h3>')
        a.push('<h3 id="8">Relaciones familiares o importantes, pareja, matrimonio, socios o tipo de relacion con respecto a los demás en general en especial lo que vemos en los demás que nos cuesta ver en nosotros mismos</h3>')
        a.push('<h3 id="9">Asuntos de nuestra vida relacionados con lo oculto, lo que ocultamos, asuntos relacionados con temas tabú, sexo, poder, control, administración, gestión de recursos ajenos o incluso coas de las que podríamos desapegarnos</h3>')
        a.push('<h3 id="10">Asuntos relacionados con los sistemas de creencias, la manera de creer, aprender, expandir la consciencia, las filosofías de vida, los estudios superiores, el acercamiento a la sabiduría, tipo de relación con los maestros, la capacidad de guiar, viajar y esparcir nuestra energía hacia los demás</h3>')
        a.push('<h3 id="11">Asuntos relacionados con la profesión, el trabajo, la relacion con el poder, el gobierno, los jefes y la autoridad en general, la etapa más alta de nuestra vida, nuestros máximos logros y exposición pública</h3>')
        a.push('<h3 id="12">Modos y maneras de relacionarse con los grupos, amistades y organizaciones en donde se podría participar involucrando el ego en un entorno rodeado de otros egos, la integración en donde ir a llevar cambios, libertad, aportar soluciones o ideas para actualizar y mejorar las cosas hacia el futuro</h3>')
        a.push('<h3 id="13">Asuntos relacionados con el desarrollo espiritual, el ser interior, nuestra zona cótica y desconocida, la mente oculta, el inconsciente, lo que vivimos en el vientre materno, la conexión con el árbol genealógico o el más allá</h3>')
        return a
    }
    function deleteAll(){
        let fileList=getFileList()
        ta1.text+='\n\n'
        for(var i=0;i<fileList.length;i++){
            ta1.text+='Se elimina: '+fileList[i]+'\n'
            unik.deleteFile(fileList[i])
        }
        ta1.text+='\nSe eliminaron todos los archivos.'
    }
    function mkAllFilesToOne(){
        let aFileList=getFileList()
        let aTitList=getArrayHtmlTits()
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        ta1.text+=logData\n'
        c+='        let m0=logData.split("Url de Carta: ")\n'
        c+='        Qt.openUrlExternally(m0[1].replace(/\\n/g, \'\'))\n'
        c+='        uqp'+ms+'.destroy(15000)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        console.log(\'zm.load() python3 "'+unik.currentFolderPath()+'/py/'+app.sweBodiesPythonFile+'" '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+' '+hsys+' '+unik.currentFolderPath()+' '+valt+'\')\n'
        c+='        let cmd=\'python3 "'+unik.currentFolderPath()+'/mkArchivoFinal.py" "'+apps.gitHubHtmlRepUrl+'/Carta_Completa_de_'+app.cNom+'.html"  "'+aFileList.toString()+'" "'+aTitList.toString()+'"\'\n'
        c+='        run(cmd)\n'
        c+='        console.log(cmd)\n'
        //c+='        Qt.quit()\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, app, 'uqpswecode')
    }
    function mkAspsRequest(){
        let cons=getAspCons()
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        //c+='        ta1.text+=logData\n'
        c+='        ta1.text+="\\nSe obtuvieron los aspectos.\\n"\n'
        c+='        app.uAspsData=logData\n'
        c+='        unik.setFile(unik.getPath(3)+\'/astromaker/\'+app.cNom+\'/asps.html\',logData)\n'
        c+='        tCheck.start()\n'
        c+='        uqp'+ms+'.destroy(3000)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        if(apps.enableDev){
            c+='        uqp'+ms+'.run(\'python3 ./ds_dev.py "asps"\')\n'
        }else{
            c+='        uqp'+ms+'.run(\'python3 ./ds.py "'+cons+'"\')\n'
        }
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, app, 'uqpdscode')
    }
    function mkHouseRequest(cons, h){
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        ta1.text+=logData\n'
        //c+='        app.uAspsData=logData\n'
        c+='        uqp'+ms+'.destroy(3000)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        uqp'+ms+'.run(\'python3 ./ds.py "'+cons+'"\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, app, 'uqpdscode')
    }
    function getHtmlHead(){
        let jd=unik.getFile(apps.uFilePath)
        let j=JSON.parse(jd)
        let nom=j.params.n.replace(/_/g, ' ')
        let vd=j.params.d
        let vm=j.params.m
        let va=j.params.a
        let vh=j.params.h
        let vmin=j.params.min
        let vgmt=j.params.gmt
        let vlon=j.params.lon
        let vlat=j.params.lat
        let valt=j.params.alt
        let vciudad=j.params.c
        let fecha=vd+'/'+vm+'/'+va
        let hora=vh+':'+vmin+'<b> GMT:</b> '+vgmt
        let en=vciudad+' <b>Geolocalización:</b> Latitud '+vlat+'  Longitud '+vlon
        let stringInfo=''
        if(j.params.g==='m'){
            stringInfo='Nacido'
        }else if(j.params.g==='m'){
            stringInfo='Nacida'
        }else{
            stringInfo='Persona nacida'
        }
        stringInfo+=' el día '+fecha+' a la hora '+hora+' en '+en+'.'

        let s='<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carta Natal de '+nom+'</title>
    <style>
        body {
            background-color: black;
            color: white;
        }
    </style>
</head>
<body>
<h1>Carta Natal de '+nom+'</h1>

<h3>'+stringInfo+'</h3>'
        return s
    }
    function sendMessage(msg){
        var xhr = new XMLHttpRequest();
        var url = "https://api.pushover.net/1/messages.json";
        var params = "token=a7biiubgzgcjjm4pdp8s8wghcxh81k" +
                "&user=udj7y27mkawju5mtmph7r7qxr6ng7b" +
                "&message=" + encodeURIComponent(msg);

        xhr.open("POST", url, true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    //log.lv("Notificación enviada exitosamente:" + xhr.responseText);
                    // Aquí podrías mostrar un mensaje al usuario
                } else {
                    //log.lv("Error al enviar la notificación:" + xhr.status, xhr.responseText);
                    // Aquí podrías mostrar un mensaje de error al usuario
                }
            }
        };

        xhr.send(params);
    }
    function getAspCons(){
        let s='Por favor, genera el siguiente contenido estrictamente en formato de texto plano, sin incluir ningún texto o comentario adicional antes o después de la respuesta.'
        s+='Te enviaré una lista de cuerpos astrológicos.\n'
        s+='En esta lista están los grados. En base a estos grados, quiero de que retornes como respuesta una lista con los aspectos tales como conjunción, oposición, cuadratura, sextil, trígono y quincuncio.\n'
        s+='No quiero que me respondas con ninguna otra explicación extra. Respondeme en formato de texto plano. En cada renglon quiero por ejemplo: Sol conjunción Marte, en otra línea, Sol cuadratura Luna.\nAqui tienes la lista.\n\n'
        for(var i=0;i<app.aBodies.length;i++){
            let bd=app.uFullParams.pc['c'+i]
            s+=''+bd.nom+' °'+parseFloat(bd.gdec).toFixed(2)+'\n'
        }
        return s.replace(/\\/g, '\\\\')
    }
    function getConsHouse(h){
        let s='Por favor, genera el siguiente contenido estrictamente en formato HTML, sin incluir ningún texto o comentario adicional antes o después de la respuesta HTML. Por favor, genera únicamente el código HTML para una lista desordenada (<ul>) con los siguientes elementos como ítems de lista (<li>), sin incluir las etiquetas <html>, <head>, <body> ni ningún otro texto o comentario adicional antes o después del código solicitado. '
        s+='Te hago una consulta astrológica. Te enviaré una lista de cuerpos astrológicos con sus respectivos aspectos en relación con otros cuerpos. '
        if(h===1){
            s+='En el contexto de casa 1, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de la personalidad, el yo, lo que se muestra desde la esencia particular hacia los demás, el yo físico, qué impronta dejamos como impresión a los demás y según nuestro signo ascendente de esta casa 1, en qué area de nuestra vida nos repercute. Además otros tipos de areas de la vida que tu sepas que están relacionados con la casa 1 como ser contexto de nacimiento, momento del parto o inicio de nuestros primeros años de vida. Pueden ser manera de presentarse, de avanzar e tipos de impulsos. '
        }
        if(h===2){
            s+='En el contexto de casa 2, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de la materialización de nuestros deseos, sueños, cómo expresaremos nuestra voluntad, con qué tipo e intensidad nos apegaremos y a qué cosas de qué tipo, asuntos relacionados con nuestra capacidad de materializar y lograr las cosas y los asuntos relacionados con el dinero, recursos, conexión e interacción con el confort, el medio ambiente, la naturaleza, el arte y los placeres de la vida. '
        }
        if(h===3){
            s+='En el contexto de casa 3, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de la comunicación, tipo de entorno cercano y tipo de interacción con el mismo o tipos de medios de transporte o tipos de frecuencias y/o distancias. Maneras y características de la expresividad, tipo de dinámica mental, modos de moverse en el entorno cercano, el acceso a la información, los diálogos, el aprendizaje, el conocimiento y la educación. '
        }
        if(h===4){
            s+='En el contexto de casa 4, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano del hogar, la infancia, la tradición familiar, la conexión con las raíces del árbol genealógico, la madre o los abuelos, del sitio o lugar del desarrollo de la infancia, del nido de donde se viene, la conexión con la historia, con el pasado, los recuerdos, la nostalgia, tipo de emocionalidad y/o inestabilidad emocional. '
        }
        if(h===5){
            s+='En el contexto de casa 5, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de la identidad, el ego, la expresividad de la esencia interior, la creatividad, el deseo y las posibilidades de crear y/o procrear, tener hijos y el tipo de vínculo con ellos. Características o salud del auto estima y la capacidad de aportar al juego del amor, del romance y jugar con los hijos, sobrinos, mascotas o la capacidad de liderar en general. Las características que permitan o no ocupar un lugar en el centro de la escena en distintas etapas de la vida. '
        }
        if(h===6){
            s+='En el contexto de casa 6, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano laboral, las rutinas y la salud. Además otros tipos de areas de la vida que tu sepas que están relacionados con la casa 6. Capacidad de poner los pies sobre la tierra, ser prácticos y ordenas las cosas de la vida. Pueden ser mascotas, higiene, practicidad etc. '
        }
        if(h===7){
            s+='En el contexto de casa 7, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de las relaciones familiares más importantes, las relaciones de pareja, el matrimonio, los tipos de noviazgos, los tipos de socios, la relación con los demás en general. Desde el punto de vista psicológico, qué tipo de lección o prueba se debe entender si tomamos a la casa 7 como un espejo que nos devuelve lo que vemos en los demás y no somos capaces de ver de nosotros mismos. '
        }
        if(h===8){
            s+='En el contexto de casa 8, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de lo oculto, lo misterioso, el tipo de interacción y dominio de todas las energía no materiales que mueven el mundo. Como ser el amor, la confianza, la manipulación, los secretos, deseos, sueños, control, pocesividad, sexo, dinero y asuntos tabú. Lo que involucra los asuntos de herencias, contabilidad, gestion, administración o control de recursos ajenos. El desapejo y la profundidad psicológica en lo profundo de la psique y lo emocional. '
        }
        if(h===9){
            s+='En el contexto de casa 9, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano del sistema de creencias, la filosofía de vida, los asuntos relacionados con la sabiduría, los maestros, los asuntos sociales, religiosos, la historia, la filosofía y los viajes. La relación con el extranjero, las culturas diferentes, la capacidad de elevar o expandir el nivel de consciencia, los estudios superiores o el desarrollo espiritual. El tipo de sed o impulsos sexuales, el tipo de respeto a los compromisos, las promesas y el tipo de necesidad de expandir la energía propia en forma de amor visto como infidelidad o engaño. '
        }
        if(h===10){
            s+='En el contexto de casa 10, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano profesional, la etapa o status más alto y pleno de nuestra vida. Los asuntos relacionados con el trabajo, el poder de mando o los gobiernos, el Estado o las fuerzas de seguridad, el tipo de relación con los jefes, padres o la autoridad en general. Los asuntos relacionados con las normas, reglas, capacidad de crear reglas y castigos, de aceptar reglas e incluso probabilidades de ser castigados o expuestos visible y públicamente. Tipo de firemeza para estructurar la vida, saliendo del hogar y afrontando el desafío de lograr los objetivos más altos que nos plantea la vida. '
        }
        if(h===11){
            s+='En el contexto de casa 11, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de las relaciones con los grupos en donde nuestro ego o esencia interior en lo particular se vincula entre otros. Los tipos de amigos y el valor que se le dá a la amistad. La capacidad de participar, involucrarse y ser parte de algo comunitario. Las propias características de la búsqueda del cambio en especial el que volcamos hacia los grupos, nuestra capacidad de aportar a los grupos, organizaciones, fundaciones, entornos religiosos, sociales o políticos. Asuntos relacionados con la capacidad de actualización, de actualizar el chip mental, la capacidad de tener buenas y nuevas ideas, revolucionarias, que aportan solución por contar con una visión global, elevada y futurista o avanzada a los tiempos. La sed de libertad en especial en cuanto a la expresión. '
        }
        if(h===12){
            s+='En el contexto de casa 12, quiero que me interpretes cómo se pueden manifestar positiva y negativamente. Dime 5 maneras positivas y 5 maneras negativas. Necesito saber cómo se podrían manifestar los siguientes cuerpos astrológicos en el plano de la espiritualidad, la mente oculta, el inconsciente, toda la parte de nuestro ser que esconde nuestra caótica e incomprensible conexión con el inconsciente colectivo, nuestro árbol genealógico, lo que vivimos en el vientre materno. Asuntos relacionados con el desarrollo espiritual, nuestro camino hacia el interior, nuestra capacidad de sentir, presentir o intuir cosas del más allá o que no se perciben con los 5 sentidos. Nuestra parte metafísica. Toda nuestra perte caótica que no podemos ver ni conocer y a veces nos lleva a un naufragio en algunas areas de la vida. '
        }

        let houseIs=app.uFullParams.ph['h'+h].is
        let strCuspide='La cúspide de la casa '+h+' está en el signo '+app.aSigns[houseIs]+'. '

        let bCuspSign=-1
        let bCuspDeg=0.0
        let bCuspHouse=-1
        let bReg

        //Aries
        if(houseIs===app.aSigns.indexOf('Aries')){
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Marte')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de Aries, Marte, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Tauro y Libra
        if(houseIs===app.aSigns.indexOf('Tauro') || houseIs===app.aSigns.indexOf('Libra')){
            let sc=houseIs===1?'Tauro':'Libra'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Venus')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Venus, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Géminis y Virgo
        if(houseIs===app.aSigns.indexOf('Géminis') || houseIs===app.aSigns.indexOf('Virgo')){
            let sc=houseIs===2?'Géminis':'Virgo'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Mercurio')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Mercurio, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Cáncer
        if(houseIs===app.aSigns.indexOf('Cáncer')){
            let sc='Cáncer'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Luna')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Luna, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Leo
        if(houseIs===app.aSigns.indexOf('Leo')){
            let sc='Leo'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Sol')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Sol, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Escorpio
        if(houseIs===app.aSigns.indexOf('Escorpio')){
            let sc='Escorpio'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Marte')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente y co-regente de '+sc+', Marte y Plutón, en esta carta natal el planeta Marte se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+' '
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Plutón')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='y Plutón se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Sagitario
        if(houseIs===app.aSigns.indexOf('Sagitario')){
            let sc='Sagitario'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Júpiter')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Júpiter, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Capricornio
        if(houseIs===app.aSigns.indexOf('Capricornio')){
            let sc='Capricornio'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Saturno')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Saturno, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Acuario
        if(houseIs===app.aSigns.indexOf('Acuario')){
            let sc='Acuario'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Urano')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Urano, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }
        //Piscis
        if(houseIs===app.aSigns.indexOf('Piscis')){
            let sc='Piscis'
            bReg=app.uFullParams.pc['c'+app.aBodies.indexOf('Neptuno')]
            bCuspSign=app.aSigns[bReg.is]
            bCuspDeg=parseFloat(bReg.gdec).toFixed(4)
            bCuspHouse=bReg.ih
            strCuspide+='Ten en cuenta que el regente de '+sc+', Neptuno, en esta carta natal se encuentra en el signo '+bCuspSign+' en el °'+bCuspDeg+' de la casa '+bCuspHouse+'. '
        }

        s+=strCuspide+'\n'

        let aBodies=[]
        let strBodiesInHouse=''
        for(var i=0;i<app.aBodies.length;i++){
            let bd=app.uFullParams.pc['c'+i]
            if(bd.ih===h){
                aBodies.push(i)
                //strBodiesInHouse=' '+bd.nom
            }
        }
        let strListOrNotList=''
        let cantBodiesListInHouse=0
        let linesBodieList=app.uBodiesDataList.split('\n')
        for(i=0;i<linesBodieList.length;i++){
            if(linesBodieList[i].indexOf('casa '+h+',')>=0){
                if(cantBodiesListInHouse===0){
                    strListOrNotList+=(' '+linesBodieList[i]).replace(',', ';')+'\n'
                }else{
                    strListOrNotList+=''+(' '+linesBodieList[i]).replace(',', ';')+'\n'
                }
                cantBodiesListInHouse++
            }
        }
        strListOrNotList+='. \n'
        if(cantBodiesListInHouse===0){
            s+='\nTen en cuenta que no hay cuerpos astrológicos en la casa '+h+'.\n'
        }else if(cantBodiesListInHouse===1){
            s+='\nEste es el único cuerpo astrológico en la casa '+h+':\n'//+strBodiesInHouse+'\n'
        }else{
            s+='\nAquí tienes la lista de cuerpos astrológicos en casa '+h+':\n'//+strBodiesInHouse+'\n'
        }
        s+=strListOrNotList
        s+='\nAspectos astrológicos: '
        for(i=0;i<aBodies.length;i++){
            let lines=app.uAspsData.split('\n')
            for(var i2=0;i2<lines.length;i2++){
                let bn=app.aBodies[aBodies[i]]
                if(lines[i2].indexOf(bn)>=0){
                    s+=lines[i2]+';\n'
                }
            }
        }
        if(apps.desTec){
            s+='\nEn la medida de lo posible, en cada explicación, aclara y detalla el aspecto en cuestión que provoca la manifestación descripta en cada item de tu respuesta.'
        }else{
            s+='\nNo incluyas en cada explicación el aspecto en cuestión ni los detalles técnicos del mismo que provoca la manifestación descripta en cada item de tu respuesta.'
        }
        s+='\nLa respuesta la quiero en formato html tipo lista, en párrafos de 2 o 3 oraciones.  Solo incluye los tags html de la lista porque tu respuesta se incluirá dentro de un html globar que ya tendrá los tags html, head, title y body. No quiero que cada lista esté enumerada con el estilo de números tipo 1., 2., 3., en cambio quiero que solo se decoren los items de la lista con el punto redondo. En la parte superior de la lista por dentro del tag <h4> los subtítulos "Manifestaciones Positivas" o "Manifestaciones Negativas" según correspondan. No quiero que me expliques nada extra antes o despues de los datos requeridos. No incluyas datos o información por fuera o extra a las 2 listas de manifestaciones positivas y negativas.'
        return s
    }
    function htmlToText(htmlString) {
      const h3Regex = /<h3[^>]*>(.*?)<\/h3>/i;
      const match = htmlString.match(h3Regex);
      if (match && match[1]) {
        return match[1];
      } else {
        return "";
      }
    }
}
