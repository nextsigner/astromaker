import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import ZoolControlsTime 1.0
import ZoolTextInput 1.0
//import "../../comps" as Comps
//import "../../js/Funcs.js" as JS

import ZoolText 1.0
import ZoolButton 1.2

Rectangle {
    id: r
    width: parent.width
    height: parent.height
    color: app.c1
    border.width: 2
    border.color: app.c2

    property alias tiN: tiNombre.t
    property alias tiC: tiCiudad.t

    property real lat:-100.00
    property real lon:-100.00
    property int alt:0

    property real ulat:-100.00
    property real ulon:-100.00
    property real ualt:0

    property string uFileNameLoaded: ''



    Settings{
        id: settings
        fileName: 'zoolFileMaker.cfg'
        property bool showModuleVersion: false
        property bool inputCoords: false
    }
    Flickable{
        id: flk
        width: r.width
        height: r.height
        contentWidth: r.width
        contentHeight: col.height+app.fs*3
        clip: true
        anchors.horizontalCenter: parent.horizontalCenter
        Column{
            id: col
            spacing: app.fs*0.75
            anchors.horizontalCenter: parent.horizontalCenter
            Item{width: 1; height: app.fs; visible: colXConfig.visible}
            Column{
                id: colXConfig
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Column{
                spacing: app.fs*0.35
                anchors.horizontalCenter: parent.horizontalCenter
                ZoolText{
                    text: '<b>Crear una nueva carta</b>'
                    font.pixelSize: app.fs*0.65
                    color: 'white'
                }
                ZoolText{
                    text: 'Mediante este formulario usted puede crear un nuevo esquema o mapa  energético, carta natal u otros.'
                    w: r.width-app.fs
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                }
            }
            Item{width: 1; height: app.fs; visible: colXConfig.visible}
            ZoolTextInput{
                id: tiNombre
                width: r.width-app.fs*0.5
                t.font.pixelSize: app.fs*0.65
                anchors.horizontalCenter: parent.horizontalCenter
                KeyNavigation.tab: controlTimeFecha
                t.maximumLength: 30
                borderColor:app.c2
                borderRadius: app.fs*0.25
                padding: app.fs*0.25
                horizontalAlignment: TextInput.AlignLeft
                onEnterPressed: {
                    controlTimeFecha.focus=true
                    controlTimeFecha.cFocus=0
                }
                Text {
                    text: 'Nombre'
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top
                }
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                ZoolText{
                    id: labelGenero
                    text: 'Género: '
                    w: app.fs*2.5
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    anchors.verticalCenter: parent.verticalCenter
                }
                ComboBox{
                    id: cbGenero
                    model: ['No Binario', 'Femenino', 'Masculino']
                    width: r.width-labelGenero.w-app.fs
                    font.pixelSize: app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle{
                        width: parent.width+8
                        height: parent.height+8
                        color: 'transparent'
                        border.width: 4
                        anchors.centerIn: parent
                        visible: cbGenero.focus
                        SequentialAnimation on border.color{
                            running: parent.visible
                            loops: Animation.Infinite
                            ColorAnimation {
                                from: "red"
                                to: "yellow"
                                duration: 300
                            }
                            ColorAnimation {
                                from: "yellow"
                                to: "red"
                                duration: 300
                            }
                        }
                    }
                }
            }
            Row{
                spacing: app.fs*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                ZoolControlsTime{
                    id: controlTimeFecha
                    gmt: 0
                    fs: r.width*0.07
                    KeyNavigation.tab: tiCiudad.t
                    setAppTime: false
                    onGmtChanged:{

                    }
                    onCurrentDateChanged: {

                        //log.l('PanelVN CurrenDate: '+currentDate.toString())
                        //log.visible=true
                        //log.x=xApp.width*0.2
                    }
                    Text {
                        text: 'Fecha'
                        font.pixelSize: app.fs*0.5
                        color: 'white'
                        anchors.bottom: parent.top
                    }
                }
            }
            ZoolTextInput{
                id: tiCiudad
                width: tiNombre.width
                t.font.pixelSize: app.fs*0.65;
                KeyNavigation.tab: cbInputCoords.checked?tiLat.t:tiAlt.t
                t.maximumLength: 50
                borderColor:app.c2
                borderRadius: app.fs*0.25
                padding: app.fs*0.25
                horizontalAlignment: TextInput.AlignLeft
                onTextChanged: {
                    tSearch.restart()
                    t.color='white'
                }
                Text {
                    text: 'Lugar, ciudad, provincia,\nregión y/o país de nacimiento'
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    anchors.bottom: parent.top
                }
            }
            Column{
                id: colTiLonLat
                anchors.horizontalCenter: parent.horizontalCenter
                visible: cbInputCoords.checked

                Row{
                    spacing: app.fs
                    anchors.horizontalCenter: parent.horizontalCenter
                    ZoolTextInput{
                        id: tiLat
                        //width: r.width*0.5-app.fs*0.5
                        //width: r.width*0.15-app.fs*0.5
                        w: r.width*0.4-app.fs*0.5
                        t.font.pixelSize: app.fs*0.65
                        anchors.verticalCenter: parent.verticalCenter
                        KeyNavigation.tab: tiLon.t
                        t.maximumLength: 10
                        t.validator: RegExpValidator {
                            regExp: RegExp(/^(\+|\-)?0*(?:(?!999\.9\d*$)\d{0,3}(?:\.\d*)?|999\.0*)$/)
                        }
                        borderColor:app.c2
                        borderRadius: app.fs*0.25
                        padding: app.fs*0.25
                        horizontalAlignment: TextInput.AlignLeft
                        property bool valid: false
                        Timer{
                            running: r.visible && cbInputCoords.checked
                            repeat: true
                            interval: 100
                            onTriggered: {
                                parent.valid=parent.t.text===''?false:(parseFloat(parent.t.text)>=-180.00 && parseFloat(parent.t.text)<=180.00)
                                if(parent.valid){
                                    r.ulat=parseFloat(parent.t.text)
                                }else{
                                    r.ulat=-1
                                }
                            }
                        }
                        Rectangle{
                            width: parent.width+border.width*2
                            height: parent.height+border.width*2
                            anchors.centerIn: parent
                            color: 'transparent'
                            border.width: 4
                            border.color: 'red'
                            visible: parent.t.text===''?false:!parent.valid
                        }
                        onEnterPressed: {
                            //controlTimeFecha.focus=true
                            //controlTimeFecha.cFocus=0
                        }
                        Text {
                            text: 'Latitud'
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            //anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                        }
                    }
                    ZoolTextInput{
                        id: tiLon
                        //width: r.width*0.15-app.fs*0.5
                        w: r.width*0.4-app.fs*0.5
                        t.font.pixelSize: app.fs*0.65
                        anchors.verticalCenter: parent.verticalCenter
                        KeyNavigation.tab: botCrear.visible&&botCrear.opacity===1.0?botCrear:botClear
                        t.maximumLength: 10
                        t.validator: RegExpValidator {
                            regExp: RegExp(/^(\+|\-)?0*(?:(?!999\.9\d*$)\d{0,3}(?:\.\d*)?|999\.0*)$/)
                        }
                        borderColor:app.c2
                        borderRadius: app.fs*0.25
                        padding: app.fs*0.25
                        horizontalAlignment: TextInput.AlignLeft
                        property bool valid: false
                        Timer{
                            running: r.visible && cbInputCoords.checked
                            repeat: true
                            interval: 100
                            onTriggered: {
                                parent.valid=parent.t.text===''?false:(parseFloat(parent.t.text)>=-180.00 && parseFloat(parent.t.text)<=180.00)
                                if(parent.valid){
                                    r.ulon=parseFloat(parent.t.text)
                                }else{
                                    r.ulon=-1
                                }
                            }
                        }
                        Rectangle{
                            width: parent.width+border.width*2
                            height: parent.height+border.width*2
                            anchors.centerIn: parent
                            color: 'transparent'
                            border.width: 4
                            border.color: 'red'
                            visible: parent.t.text===''?false:!parent.valid
                        }
                        //onPressed: {
                        onEnterPressed: {
                            //controlTimeFecha.focus=true
                            //controlTimeFecha.cFocus=0
                        }
                        Text {
                            text: 'Longitud'
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            //anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                        }
                    }
                }
                Item{width: 1; height: app.fs*0.5;visible: cbInputCoords.checked}
                Text{
                    text: tiLat.t.text===''&&tiLon.t.text===''?'Escribir las coordenadas geográficas.':
                                                                (
                                                                    tiLat.valid && tiLon.valid?
                                                                        'Estas coordenadas son válidas.':
                                                                        'Las coordenadas no son correctas'
                                                                    )
                    font.pixelSize: app.fs*0.5
                    color: app.c2
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: cbInputCoords.checked
                }
            }
            Column{
                id: colLatLon
                anchors.horizontalCenter: parent.horizontalCenter
                visible: r.lat===r.ulat&&r.lon===r.ulon
                //height: !visible?0:app.fs*3
                Text{
                    text: 'Lat:'+r.lat
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.lat!==-100.00?1.0:0.0
                }
                Text{
                    text: 'Lon:'+r.lon
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.lon!==-100.00?1.0:0.0
                }
            }
            Column{
                visible: !colLatLon.visible
                //height: !visible?0:app.fs*3
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: 'Error: Corregir el nombre de ubicación'
                    font.pixelSize: app.fs*0.25
                    color: 'white'
                    visible: r.ulat===-1&&r.ulon===-1
                }
                Text{
                    text: 'Lat:'+r.ulat
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.ulat!==-100.00?1.0:0.0
                }
                Text{
                    text: 'Lon:'+r.ulon
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.ulon!==-100.00?1.0:0.0
                }
            }
            Row{
                spacing: app.fs*0.5
                anchors.horizontalCenter: parent.horizontalCenter
                Item{
                    id: xAlt
                    width: app.fs*3
                    height: app.fs*3
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
                    ZoolTextInput{
                        id: tiAlt
                        text: r.ualt
                        //width: app.fs*3
                        t.font.pixelSize: app.fs*0.65
                        anchors.centerIn: parent
                        //anchors.horizontalCenter: parent.horizontalCenter
                        KeyNavigation.tab: botCrear.visible&&botCrear.opacity===1.0?botCrear:botClear

                        t.maximumLength: 4
                        borderColor:app.c2
                        borderRadius: app.fs*0.25
                        padding: app.fs*0.25
                        horizontalAlignment: TextInput.AlignLeft
                        property int uNum: 0
                        onTextChanged:{
                            let t=text
                            t = t.replace(/[^\d]/g, '');
                            let num = parseInt(t);
                            if (isNaN(num) || num < 0 || num > 20000) {
                                r.ualt=0
                                r.alt=0
                            } else {
                                r.ualt=num
                                r.alt=num
                            }
                            t=''+num
                            if(t.indexOf('0')===0 && t.length>1){
                                t = t.substring(1, text.length-1)
                            }
                            text=isNaN(t)?'0':t
                            tiAlt.uNum=num
                        }
                        onEnterPressed: {
                            //controlTimeFecha.focus=true
                            //controlTimeFecha.cFocus=0
                        }
                        Text {
                            text: 'Altura'
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            //anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                        }
                    }
                }
                Row{
                    spacing: app.fs*0.5
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    Text{
                        text: 'Ingresar\ncoordenadas\nmanualmente'
                        font.pixelSize: app.fs*0.5
                        color: app.c2
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    CheckBox{
                        id: cbInputCoords
                        checked: settings.inputCoords
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckedChanged: settings.inputCoords=checked
                    }
                }
            }
            Column{
                id: colInforme
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: 'Informe'
                    font.pixelSize: app.fs*0.5
                    color: app.c2
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    id: xInforme
                    width: r.width-app.fs*0.5
                    height: app.fs*6
                    color: app.c1
                    border.width: 1
                    border.color: app.c2
                    radius: app.fs*0.1
                    clip: true
                    Flickable{
                        contentWidth: xInforme.width
                        contentHeight: taInforme.contentHeight+app.fs
                        anchors.fill: parent
                        ScrollBar.vertical: ScrollBar{}
                        TextArea{
                            id: taInforme
                            width: xInforme.width-app.fs*0.5
                            font.pixelSize: app.fs*0.5
                            color: app.c2
                            wrapMode: TextArea.WordWrap
                        }
                    }
                }
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: app.fs*0.25
                Button{
                    id: botClear
                    text: 'Limpiar'
                    font.pixelSize: app.fs*0.5
                    opacity:  r.lat!==-100.00||r.lon!==-100.00||tiNombre.text!==''||tiCiudad.text!==''?1.0:0.0
                    enabled: opacity===1.0
                    onClicked: {
                        clear()
                    }
                }
                Button{
                    id: botCrear
                    text: 'Crear'
                    font.pixelSize: app.fs*0.5
                    KeyNavigation.tab: tiNombre.t
                    visible: r.ulat!==-1&&r.ulon!==-1&&tiNombre.text!==''&&tiCiudad.text!==''
                    onClicked: {
                        if(!cbInputCoords.checked){
                            searchGeoLoc(true)
                        }else{
                            r.lat=parseFloat(tiLat.t.text)
                            r.lon=parseFloat(tiLon.t.text)
                            r.ulat=r.lat
                            r.ulon=r.lon
                            setNewJsonFileData()
                        }
                    }
                    //
                    /*Timer{
                        running: r.visible
                        repeat: true
                        interval: 3000
                        onTriggered: {
                            let p=zfdm.getJsonAbs().params
                            let cNom=p.n.replace(/_/g, ' ')
                            let nom=tiNombre.t.text.replace(/_/g, ' ')
                            //log.lv('p.n: '+p.n)
                            //log.lv('nom: '+nom)
                            if(cNom===nom){
                                botCrear.text='Modificar'
                            }else{
                                botCrear.text='Crear'
                            }
                        }
                    }*/

                    //                    Timer{
                    //                        running: false//r.visible
                    //                        repeat: true
                    //                        interval: 1000
                    //                        onTriggered: {
                    //                            let nom=tiNombre.t.text.replace(/ /g, '_')
                    //                            let fileName=apps.workSpace+'/'+nom+'.json'
                    //                            if(unik.fileExist(fileName)){
                    //                                r.uFileNameLoaded=tiNombre.text
                    //                                let jsonFileData=unik.getFile(fileName)
                    //                                let j=JSON.parse(jsonFileData)
                    //                                let dia=''+j.params.d
                    //                                if(parseInt(dia)<=9){
                    //                                    dia='0'+dia
                    //                                }
                    //                                let mes=''+j.params.m
                    //                                if(parseInt(mes)<=9){
                    //                                    mes='0'+mes
                    //                                }
                    //                                let hora=''+j.params.h
                    //                                if(parseInt(hora)<=9){
                    //                                    hora='0'+hora
                    //                                }
                    //                                let minuto=''+j.params.min
                    //                                if(parseInt(minuto)<=9){
                    //                                    minuto='0'+minuto
                    //                                }
                    //                                let nt=new Date(parseInt(j.params.a), parseInt(mes - 1), parseInt(dia), parseInt(hora), parseInt(minuto))
                    //                                controlTimeFecha.currentDate=nt
                    //                                controlTimeFecha.gmt=j.params.gmt
                    //                                if(tiCiudad.text.replace(/ /g, '')===''){
                    //                                    tiCiudad.text=j.params.c
                    //                                }
                    //                                r.lat=j.params.lat
                    //                                r.lon=j.params.lon
                    //                                r.ulat=j.params.lat
                    //                                r.ulon=j.params.lon
                    //                                let vd=parseInt(tiFecha1.t.text)
                    //                                let vm=parseInt(tiFecha2.t.text)
                    //                                let vh=parseInt(tiHora1.t.text)
                    //                                let vmin=parseInt(tiHora2.t.text)
                    //                                let vgmt=controlTimeFecha.gmt//tiGMT.t.text
                    //                                let vCiudad=tiCiudad.t.text.replace(/_/g, ' ')
                    //                                if(j.params.d!==vd||j.params.m!==vm||j.params.a!==va||j.params.h!==vh||j.params.min!==vmin||r.lat!==r.ulat||r.lon!==r.ulon){
                    //                                    botCrear.text='Modificar'
                    //                                }else{
                    //                                    botCrear.text='[Crear]'
                    //                                }
                    //                            }else{
                    //                                botCrear.text='Crear'
                    //                            }
                    //                        }
                    //                    }

                }
            }
        }
    }
    Timer{
        id: tSearch
        running: false
        repeat: false
        interval: 2000
        onTriggered: searchGeoLoc(false)
    }
    //    Timer{
    //        id: tLoadTemp
    //        running: false
    //        repeat: false
    //        interval: 2000
    //        onTriggered: {

    //        }
    //    }

    function searchGeoLoc(crear){
        const lugarABuscar = tiCiudad.t.text
        obtenerCoordenadas(lugarABuscar)
        .then(coordenadas => {
                  //console.log(`Las coordenadas de ${lugarABuscar} son:`);
                  //console.log(`Latitud: ${coordenadas.latitud}`);
                  //console.log(`Longitud: ${coordenadas.longitud}`);
                  if(coordenadas){
                      if(r.lat===-1&&r.lon===-1){
                          tiCiudad.t.color="red"
                      }else{
                          tiCiudad.t.color=app.c2
                          if(crear){
                              r.lat=coordenadas.latitud
                              r.lon=coordenadas.longitud
                              setNewJsonFileData()
                              r.state='hide'
                          }else{
                              r.ulat=coordenadas.latitud
                              r.ulon=coordenadas.longitud
                          }
                      }
                  }else{
                      console.log('No se encontraron las cordenadas.')
                  }
              })
        .catch(error => {
                   //console.error('Ocurrió un error:', error);
                   ta1.text=+'Ocurrió un error: '+error
               });
    }
    function setNewJsonFileData(){
        let vtipo='vn' //Esto luego lo programaré para EVENTOS tipo='even'

        let d = new Date(Date.now())
        let ms=d.getTime()
        let nom=tiNombre.t.text.replace(/ /g, '_')

        let vd=controlTimeFecha.dia
        let vm=controlTimeFecha.mes
        let va=controlTimeFecha.anio
        let vh=controlTimeFecha.hora
        let vmin=controlTimeFecha.minuto

        let vgmt=controlTimeFecha.gmt//tiGMT.t.text
        let vlon=r.lon
        let vlat=r.lat
        let valt=r.alt
        let vCiudad=tiCiudad.t.text.replace(/_/g, ' ')

        let vhsys=apps.currentHsys


        let json={}
        json.params={}
        json.params.t=vtipo
        json.params.ms=ms
        json.params.n=nom
        json.params.g='n'
        if(cbGenero.currentIndex===1)json.params.g='f'
        if(cbGenero.currentIndex===2)json.params.g='m'
        json.params.f=false
        if(botCrear.text==='Modificar'){
            //json.params.f=p.f
        }
        json.params.data=taInforme.text


        json.params.d=vd
        json.params.m=vm
        json.params.a=va
        json.params.h=vh
        json.params.min=vmin
        json.params.gmt=vgmt
        json.params.lat=vlat
        json.params.lon=vlon
        json.params.alt=valt
        json.params.c=vCiudad
        json.params.hsys=vhsys



        let folderPath=unik.getPath(3)+'/astromaker/cns'
        unik.mkdir(folderPath)
        let filePath=folderPath+'/'+tiNombre.t.text.replace(/ /g, '_')+'.json'
        unik.setFile(filePath, JSON.stringify(json, null, 2))
        apps.uFilePath=filePath
        app.loadFile(apps.uFilePath)
        //ta1.text+='Se ha creado el archivo: '+filePath
    }
    /*function enter(){
        if(botCrear.focus&&tiNombre.text!==''&&tiFecha1.text!==''&&tiFecha2.text!==''&&tiFecha3.text!==''&&tiHora1.text!==''&&tiHora2.text!==''&&tiGMT.text!==''&&tiCiudad.text!==''){
            searchGeoLoc(true)
            if(zfdm.mkFileAndLoad(json, asTemp)){
                if(apps.dev)log.lv('Archivo creado: '+json.params.n)
            }else{
                if(apps.dev)log.lv('Archivo NO creado: '+json.params.n)
            } }
    }*/
    function clear(){
        r.ulat=-100
        r.ulon=-100
        r.ualt=0
        r.lat=-100
        r.lon=-100
        r.alt=0
        tiNombre.t.text=''
        tiCiudad.t.text=''
        tiAlt.t.text='0'
        cbShared.checked=false

        controlTimeFecha.gmt=0
        let d = new Date(Date.now())
        controlTimeFecha.dia=d.getDate()
        controlTimeFecha.mes=d.getMonth()
        controlTimeFecha.anio=d.getFullYear()
        controlTimeFecha.hora=d.getHours()
        controlTimeFecha.minuto=d.getMinutes()

        tiNombre.t.focus=true

    }
    function toRight(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toRight()
        }
    }
    function toLeft(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toLeft()
        }
    }
    function toUp(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toUp()
        }
        if(cbGenero.focus){
            if(cbGenero.currentIndex>0){
                cbGenero.currentIndex--
            }else{
                cbGenero.currentIndex=cbGenero.model.length-1
            }
        }
    }
    function toDown(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toDown()
        }
        if(cbGenero.focus){
            if(cbGenero.currentIndex<cbGenero.model.length-1){
                cbGenero.currentIndex++
            }else{
                cbGenero.currentIndex=0
            }
        }
    }
    function toTab(){
        if(tiNombre.t.focus){
            cbGenero.focus=true
        }else if(cbGenero.focus){
            tiCiudad.t.focus=true
        }else{
            tiNombre.t.focus=true
        }
    }
    function setInitFocus(){
        tiNombre.t.selectAll()
        tiNombre.t.focus=true
    }
    function loadTemp(){
        if(!cbInputCoords.checked){
            searchGeoLoc(true)
        }else{
            if(r.ulat===-1&&r.ulon===-1){
                r.lat=0.0
                r.lon=0.0
                r.ulat=0.0
                r.ulon=0.0
            }else{
                r.lat=parseFloat(tiLat.t.text)
                r.lon=parseFloat(tiLon.t.text)
                r.ulat=r.lat
                r.ulon=r.lon
            }
            setNewJsonFileData()
        }
    }
    /*function setForEdit(){
        zsm.currentIndex=0
        let panel=zsm.getPanel('ZoolFileManager')
        panel.showSection('ZoolFileMaker')
        let p=zfdm.getJsonAbs().params
        tiNombre.t.text=p.n.replace(/_/g,' ')
        controlTimeFecha.dia=p.d
        controlTimeFecha.mes=p.m
        controlTimeFecha.anio=p.a
        controlTimeFecha.hora=p.h
        controlTimeFecha.minuto=p.min
        controlTimeFecha.gmt=p.gmt
        let nCtDate= new Date(p.a, p.m-1, p.d, p.h, p.min)
        controlTimeFecha.currentDate=nCtDate
        tiCiudad.t.text=p.c
        cbInputCoords.checked=true
        r.ulat=p.lat
        r.ulon=p.lon
        if(p.alt){
            r.ualt=p.alt
        }else{
            r.ualt=0
        }
        r.lat=p.lat
        r.lon=p.lon
        if(p.alt){
            r.alt=p.alt
        }else{
            r.alt=0
        }
        tiLat.t.text=parseFloat(r.lat).toFixed(2)
        tiLon.t.text=parseFloat(r.lon).toFixed(2)
        tiAlt.t.text=''+r.alt

        if(p.g){
            if(p.g==='n'){
                cbGenero.currentIndex=0
            }
            if(p.g==='f'){
                cbGenero.currentIndex=1
            }
            if(p.g==='m'){
                cbGenero.currentIndex=2
            }
        }else{
            cbGenero.currentIndex=0
        }
        taInforme.text=p.data
        //log.lv('p:'+JSON.stringify(p, null, 2))
    }*/
    function obtenerCoordenadas(lugar) {
        return new Promise((resolve, reject) => {
                               const xhr = new XMLHttpRequest();
                               const url = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(lugar)}&format=json`;

                               xhr.open('GET', url);

                               xhr.onload = function() {
                                   if (xhr.status >= 200 && xhr.status < 300) {
                                       try {
                                           const respuesta = JSON.parse(xhr.responseText);
                                           if (respuesta && respuesta.length > 0) {
                                               const latitud = parseFloat(respuesta[0].lat);
                                               const longitud = parseFloat(respuesta[0].lon);
                                               resolve({ latitud, longitud });
                                           } else {
                                               reject('No se encontraron coordenadas para el lugar
 especificado.');
                                               //log.clear()
                                               ta1.text='No se encontraron las coordenadas de geolocalización de '+tiCiudad.text
                                           }
                                       } catch (error) {
                                           reject('Error al parsear la respuesta JSON.');
                                           //log.clear()
                                           ta1.text='Hay un error de red en estos momentos. Error al solicitar las coordenadas de geolocalización de '+tiCiudad.text
                                       }
                                   } else {
                                       reject(`Error en la petición: Código de estado ${xhr.status}`);
                                       ta1.text='Hay un error de red en estos momentos. Error al solicitar las coordenadas de geolocalización de '+tiCiudad.text
                                   }
                               };

                               xhr.onerror = function() {
                                   reject('Error de red al realizar la petición.');
                                   //log.clear()
                                   ta1.text='Hay un error de red en estos momentos. Error al solicitar las coordenadas de geolocalización de '+tiCiudad.text
                               };

                               xhr.send();
                           });
    }

    // Ejemplo de uso:
    /*const lugarABuscar = "Malargue, Mendoza";
    obtenerCoordenadas(lugarABuscar)
      .then(coordenadas => {
        console.log(`Las coordenadas de ${lugarABuscar} son:`);
        console.log(`Latitud: ${coordenadas.latitud}`);
        console.log(`Longitud: ${coordenadas.longitud}`);
      })
      .catch(error => {
        console.error('Ocurrió un error:', error);
      });*/
}
