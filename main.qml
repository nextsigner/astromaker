import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import FileMaker 1.0

import Qt.labs.settings 1.0

ApplicationWindow{
    id: app
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
        property string uFilePath: '/home/ns/Documentos/astromaker/cns/Pablo.json'
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
        let f=apps.uFilePath
        if(!unik.fileExist(f)){
            ta1.text='No hay ningún archivo para procesar.'
            return
        }
        loadFile(apps.uFilePath)
        return
        let fd1=unik.getFile(f)
        let j1=JSON.parse(fd1)
        app.cNom=j1.params.n
        unik.mkdir(unik.getPath(3)+'/astromaker')
        let jd=unik.getFile('./ejemplo.json')
        let json=JSON.parse(jd)

        for(var i=0;i<Object.keys(json.pc).length;i++){
            let jbodie=json.pc['c'+i]
            lm.append(lm.addItem(jbodie, 1, 0))
            lm.append(lm.addItem(jbodie, 0, 0))
        }
        //ta1.text=JSON.stringify(json, null, 2)




    }

    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    function loadFile(url){
        if(!unik.fileExist(url))return
        let fd1=unik.getFile(url)
        let j1=JSON.parse(fd1)
        app.cNom=j1.params.n
        unik.mkdir(unik.getPath(3)+'/astromaker')
        let jd=unik.getFile(url)
        let j=JSON.parse(jd)
        mkAnRunSweRequest(j)
    }
    function loadJson(jsonString){
        let json=JSON.parse(jsonString)
        for(var i=0;i<Object.keys(json.pc).length;i++){
            let jbodie=json.pc['c'+i]
            lm.append(lm.addItem(jbodie, 1, 0))
            lm.append(lm.addItem(jbodie, 0, 0))
        }
        tCheck.start()
    }
    function check(){
        let indexForRequest=-1
        let filePathForRequest=''
        let hayTareas=false
        for(var i=0;i<lm.count;i++){
            let e=lm.get(i).e
            if(e===1)return
            let t=lm.get(i).t===1?'pos':'neg'
            let j=lm.get(i).j
            let folder=unik.getPath(3)+'/astromaker/'+app.cNom
            if(!unik.folderExist(folder)){
                unik.mkdir(folder)
            }
            let b=j.nom
            let s=app.aSigns[j.is]
            let h=j.ih
            let fileName=t+'_'+b+'_'+s+'_'+h+'.txt'
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
        }
    }
    function prepareRequest(index){
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
        cons+='Consulta sobre Astrología. Dime cómo se manifiestan en el plano astrológico, en este caso de manera '+strManPosONeg+', es decir, quiero que en tu respuesta me digas al menos 10 manifestaciones '+strManPosONeg+'s de '+b+' en el signo '+s+' en Casa '+h+'. El formato de tu respuesta debe ser la siguiente; En texto plano, en 10 párrafos, que cada párrafo comience con el tipo de manifestación, luego 2 puntos, a modo de título introductorio y 2 o 3 oraciones explicándo la manifestación en cuentión. No quiero explicación extra al inicio ni al pié. Explícaselo a una persona llamada '+app.cNom+' en segunda persona.'
        return cons
    }
    function mkAIRequest(cons, filePath, itemIndex){
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
        c+='        ta1.text+=logData\n\n'
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
        c+='        let json=(\'\'+logData)\n'
        c+='        //log.lv(\'JSON: \'+json)\n'
        c+='        ta1.text=json\n'
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
}
