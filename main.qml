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


    property string sweBodiesPythonFile: 'zool_swe_portable_2.10.3.2_v1.py'

    property int fs: Screen.width*0.02
    property color c1: 'black'
    property color c2: 'white'

    property string cNom: ''

    property var aSigns: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property var aSignsLowerStyle: ['aries', 'tauro', 'geminis', 'cancer', 'leo', 'virgo', 'libra', 'escorpio', 'sagitario', 'capricornio', 'acuario', 'piscis']
    property var aBodies: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Norte', 'N.Sur', 'Quirón', 'Selena', 'Lilith', 'Pholus', 'Ceres', 'Pallas', 'Juno', 'Vesta']

    Settings{
        id: apps
        fileName: 'astromaker.cfg'
        property bool enableAutoCons: false
        property string uFilePath
        property color backgroundColor: 'black'
        property color fontColor: 'white'
    }

    Row{
        Rectangle{
            width: app.width/3
            height: app.height
            color: 'transparent'
            border.width: 2
            border.color: app.c2
            FileMaker{id: fileMaker}
            Row{
                spacing: app.fs*0.5
                anchors.right: parent.right
                Button {
                    id: setAutoCons
                    text: apps.enableAutoCons?"Desactivar":"Activar"
                    onClicked: {
                        apps.enableAutoCons=!apps.enableAutoCons
                        tCheck.running=apps.enableAutoCons
                        if(apps.enableAutoCons)init()
                    }
                }
                Button {
                    id: openFileButton
                    text: "Abrir Archivo"
                    onClicked: fileDialog.visible = true
                }
            }
        }
        Rectangle{
            width: app.width/3
            height: app.height
            color: 'transparent'
            border.width: 2
            border.color: app.c2
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
                            let str=t===1?'<b>Pos: </b>':'<b>Neg: </b>'
                            let b=j.nom
                            let s=app.aSigns[j.is]
                            let h=j.ih
                            let deg=j.gdec
                            str+=b+' en '+s+' en Casa '+h
                            txt1.text=str
                        }
                    }
                }
            }
        }
        Rectangle{
            width: app.width/3
            height: app.height
            color: 'transparent'
            border.width: 2
            border.color: app.c2
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

    Timer{
        id: tCheck
        running: false
        repeat: true
        interval: 5000
        onTriggered: {
            if(apps.uFilePath===''){
                ta1.text='No hay ningún archivo para revisar.'
                return
            }
            check()
        }
    }

    Component.onCompleted: {
        ta1.text='Último archivo procesado: '+apps.uFilePath
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
        app.cNom=j1.params.n
        unik.mkdir(unik.getPath(3)+'/astromaker')
        let jd=unik.getFile(url)
        let j=JSON.parse(jd)
        mkAnRunSweRequest(j)
    }
    function loadJson(jsonString){
        lm.clear()
        let json=JSON.parse(jsonString.replace(/\n/g, ''))
        for(var i=0;i<Object.keys(json.pc).length;i++){
            let jbodie=json.pc['c'+i]
            lm.append(lm.addItem(jbodie, 1, 0))
            lm.append(lm.addItem(jbodie, 0, 0))
        }
        tCheck.start()
    }

    function check(){
        if(!apps.enableAutoCons)return
        let indexForRequest=-1
        let filePathForRequest=''
        let hayTareas=false
        let folder=unik.getPath(3)+'/astromaker/'+app.cNom
        for(var i=0;i<lm.count;i++){
            let e=lm.get(i).e
            if(e===1)return
            let t=lm.get(i).t===1?'pos':'neg'
            let j=lm.get(i).j
            if(!unik.folderExist(folder)){
                unik.mkdir(folder)
            }
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
        }
        if(indexForRequest>=0){
            lm.setProperty(indexForRequest, "e", 1)
            mkAIRequest(prepareRequest(indexForRequest), filePathForRequest, indexForRequest)
            //ta1.text+='Consultando: '+prepareRequest(indexForRequest)+'.\n\n'
        }
        if(!hayTareas){
            ta1.text='Aviso: No hay más tareas para realizar.\n\n'
            tCheck.stop()
            let headData=getHtmlHead()
            ta1.text+=headData
            unik.setFile(folder+'/head.html', headData)
            let footData=''
            footData+='<br><hr><br><h4>Creado por Ricardo Martín Pizarro - 2025</h4><h4>Whatsapp +54 9 1138024370</h4><hr><br>'
            footData+='</body></html>'
            unik.setFile(folder+'/foot.html', footData)
            mkAllFilesToOne()
            sendMessage('Se terminó de crear la carta de '+app.cNom)
        }
    }
    function prepareRequest(index){
        if(!tCheck.running)return ''
        let cons=''
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
        cons+='Consulta sobre Astrología. Dime cómo se manifiestan en el plano astrológico, en este caso de manera '+strManPosONeg+', es decir, quiero que en tu respuesta me digas al menos 10 manifestaciones '+strManPosONeg+'s de '+b+' en el signo '+s+' en Casa '+h+'. El formato de tu respuesta debe ser la siguiente; En formato HTML, en 10 párrafos, que cada párrafo comience con el tipo de manifestación en negrita con 2 puntos, a modo de título introductorio y 2 o 3 oraciones explicándo la manifestación en cuentión. El listado de manifestaciones debe estar en el contexto de una lista HTML. No quiero explicación extra al inicio ni al pié. Explícaselo a una persona llamada '+app.cNom.replace(/_/g, '_')+' en segunda persona. No es necesario que utilices su nombre completo. Preferentemente utiliza su primer nombre. No es necesario que en la lista enumeres con un número entero.'
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
        c+='        ta1.text="Se ha procesado la consulta '+itemIndex+'/"+lm.count\n\n'
        c+='        lm.setProperty('+itemIndex+', "e", 2)\n'
        c+='        item'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='}\n'
        c+='    Component.onCompleted: {\n'
        c+='        uqp'+ms+'.run(\'python3 ./ds.py "'+cons+'"\')\n'
        c+='    }\n'
        c+='}\n'
        let obj=Qt.createQmlObject(c, app, 'uqpcode')
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
        //c+='        ta1.text=json\n'
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
        for(var i=0;i<lm.count;i++){
            let j=lm.get(i).j
            let b=j.nom
            let s=app.aSigns[j.is]
            let h=j.ih
            let filePath=''

            let t=lm.get(i).t
            let fileName=''
            if(t===1){
                fileName='pos_'+b+'_'+s+'_'+h+'.html'
                filePath=folder+'/'+fileName
            }else{
                fileName='neg_'+b+'_'+s+'_'+h+'.html'
                filePath=folder+'/'+fileName
            }
            aFileList.push(filePath)
        }
        aFileList.push(folder+'/foot.html')
        return aFileList
    }
    function mkAllFilesToOne(){
        let aFileList=getFileList()
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        ta1.text=logData\n'
        c+='        let m0=logData.split("Url de Carta: ")\n'
        c+='        Qt.openUrlExternally(m0[1].replace(/\\n/g, \'\'))\n'
        c+='        uqp'+ms+'.destroy(3000)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        console.log(\'zm.load() python3 "'+unik.currentFolderPath()+'/py/'+app.sweBodiesPythonFile+'" '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+' '+hsys+' '+unik.currentFolderPath()+' '+valt+'\')\n'
        c+='        run(\'python3 "'+unik.currentFolderPath()+'/mkArchivoFinal.py" "'+unik.getPath(3)+'/astromaker/Carta_Completa_de_'+app.cNom+'.html"  "'+aFileList.toString()+'"\')\n'
        //c+='        Qt.quit()\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, app, 'uqpswecode')
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
}
