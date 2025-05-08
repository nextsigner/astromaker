import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Window 2.0

import QtMultimedia 5.0

ApplicationWindow {
    id: app
    visible: true
    visibility: 'FullScreen'
    width: Screen.width
    height: Screen.height
    title: "Mi Super Pac-Man"
    color: 'black'
    property string fr
    property int fs: width*0.02
    property bool dev:  false
    property var tempJson

    property int cantCellH: 36
    property int cantCellV: 18

    property int wc: app.width/app.cantCellH
    property int hc: app.height/app.cantCellV

    property var f1

    //Puntos y Niveles
    property bool nivelCompletado: false
    property int puntos: 0
    property int puntosComidos: 0
    property int puntosMax: 0
    property int nivel: 1

    Audio{
        id: aCome
        source: 'file://'+app.fr+'/sounds/come-corto.wav'
        //autoLoad: true
        //autoPlay: true
    }

    Item{
        id: grilla
        //z: gameArea.z+1
        anchors.fill: parent
        visible: false
        Column{
            anchors.centerIn: parent
            Repeater{
                model: app.cantCellV
                Rectangle{
                    width: app.width
                    height: app.hc//app.height/app.cantCellV
                    color: 'transparent'
                    border.width: 0
                    border.color: 'red'
                    Row{
                        anchors.centerIn: parent
                        Repeater{
                            model: app.cantCellH
                            Rectangle{
                                width: app.width/app.cantCellH
                                height: app.height/app.cantCellV
                                color: 'transparent'
                                border.width: 1
                                border.color: 'yellow'

                            }
                        }
                    }
                }
            }
        }
        Text{
            text: 'WC:'+app.wc+' HC:'+app.hc
            font.pixelSize: app.fs*3
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: gameArea
        anchors.fill: parent
        color: "transparent"
        opacity: pacman.vivo?1.0:0.5
        Item{
            id: xPuntos
            anchors.fill: parent
            opacity: pacman.vivo?1.0:0.0
        }

        // Laberinto
        Repeater {
            id: wallRepeater
            delegate: Rectangle {
                id: xPared
                x: modelData.x+2
                y: modelData.y+2
                width: modelData.width-4
                height: modelData.height-4
                color: 'transparent'//modelData.c
                visible: modelData.height>=app.hc && modelData.width>=app.wc?0.5:1.0
                Rectangle{
                    width: parent.width+4
                    height: parent.height+4
                    color: modelData.c
                    radius: app.wc*0.25
                    border.color: 'yellow'
                    border.width: 4
                    anchors.centerIn: parent
                    opacity: pacman.vivo?1.0:0.0
                    MouseArea{
                        enabled: app.dev
                        anchors.fill: parent
                        onClicked: {
                            app.aInsert=[]
                            let jd=unik.getFile(app.fr+'/pantalla_'+app.nivel+'.json')
                            let j=JSON.parse(jd)
                            let obj= j.paredes[index]
                            if(obj.c==='blue'){
                                obj.c='green'
                            }else if(obj.c==='green'){
                                obj.c='pink'
                            }else if(obj.c==='pink'){
                                obj.c='red'
                            }else if(obj.c==='red'){
                                obj.c='yellow'
                            }else if(obj.c==='yellow'){
                                obj.c='#ff8833'
                            }else{
                                obj.c='blue'
                            }
                            j.paredes[index]=obj
                            updatePared(j)
                        }
                    }
                    Rectangle{
                        width: app.wc*0.8
                        height: width
                        radius: width*0.5
                        anchors.centerIn: parent
                        visible: app.dev
                        Text{
                            text: '<b>'+index+'</b>'
                            font.pixelSize: app.wc*0.7
                            anchors.centerIn: parent
                        }
                    }
                }
                Rectangle{
                    id: botCfgIzq
                    width: app.wc*0.25
                    height: parent.height
                    color: 'red'
                    border.width: 2
                    border.color: '#ff8833'
                    visible: app.dev
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            let jd=unik.getFile(app.fr+'/pantalla_'+app.nivel+'.json')
                            let j=JSON.parse(jd)
                            let obj= j.paredes[index]
                            if (mouse.modifiers & Qt.ControlModifier) {
                                if(obj.width>1)obj.width--
                            }else{
                                obj.x--
                            }
                            j.paredes[index]=obj
                            xPared.updatePared(j)
                        }
                    }
                }

                Rectangle{
                    id: botCfgDer
                    width: app.wc*0.25
                    height: parent.height
                    color: 'red'
                    border.width: 2
                    border.color: '#ff8833'
                    visible: app.dev
                    anchors.right: parent.right
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            let jd=unik.getFile(app.fr+'/pantalla_'+app.nivel+'.json')
                            let j=JSON.parse(jd)
                            let obj= j.paredes[index]
                            if (mouse.modifiers & Qt.ControlModifier) {
                                obj.width++
                            }else{
                                obj.x++
                            }
                            j.paredes[index]=obj
                            xPared.updatePared(j)
                        }
                    }
                }
                Rectangle{
                    id: botCfgArriba
                    width: parent.width
                    height: app.wc*0.25
                    color: 'red'
                    border.width: 2
                    border.color: '#ff8833'
                    visible: app.dev
                    //anchors.right: parent.right
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            let jd=unik.getFile(app.fr+'/pantalla_'+app.nivel+'.json')
                            let j=JSON.parse(jd)
                            let obj= j.paredes[index]
                            if (mouse.modifiers & Qt.ControlModifier) {
                                if(obj.height>1)obj.height--
                            }else{
                                obj.y--
                            }
                            j.paredes[index]=obj
                            xPared.updatePared(j)
                        }
                    }
                }
                Rectangle{
                    id: botCfgAbajo
                    width: parent.width
                    height: app.wc*0.25
                    color: 'red'
                    border.width: 2
                    border.color: '#ff8833'
                    visible: app.dev
                    anchors.bottom: parent.bottom
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            let jd=unik.getFile(app.fr+'/pantalla_'+app.nivel+'.json')
                            let j=JSON.parse(jd)
                            let obj= j.paredes[index]
                            if (mouse.modifiers & Qt.ControlModifier) {
                                obj.height++
                            }else{
                                obj.y++
                            }
                            j.paredes[index]=obj
                            xPared.updatePared(j)
                        }
                    }
                }
                function updatePared(j){
                    unik.setFile(app.fr+'/pantalla_'+app.nivel+'.json', JSON.stringify(j, null, 2))
                    app.dev=false
                    pacman.vivo=false
                    reiniciar()
                    //loadPantalla(app.nivel)
                    //tContinueEdit.restart()
                    app.dev=true
                }
            }
        }


        // Pac-Man
        Rectangle {
            id: pacman
            //width: (app.width/app.cantCellH)//-app.wc*0.2
            //height: (app.height/app.cantCellV)//-app.wc*0.2
            //width: app.wc
            //height: width
            width: (app.width/app.cantCellH)//-app.wc*0.2
            height: (app.height/app.cantCellV)//-app.wc*0.2
            //radius: width / 2
            color: "transparent"
            border.width: 0
            border.color: 'red'
            x: (app.width/app.cantCellH)*(app.cantCellH/2)
            y: ((app.height/app.cantCellV)*(app.cantCellV))


            property bool vivo: false
            property int speed: app.wc//*0.25
            property int tSpeed: 160-(app.nivel*10)
            property string direction: "right"
            property bool mover: false


            Timer {
                id: moveTimer
                interval: pacman.tSpeed
                running: pacman.vivo
                repeat: true
                onTriggered: {
                    //if(!pacman.mover)return
                    var newX = pacman.x
                    var newY = pacman.y

                    switch (pacman.direction) {
                    case "up": newY = Math.max(pacman.y - pacman.speed, 0); break;
                    case "down": newY = Math.min(pacman.y + pacman.speed, gameArea.height - pacman.height); break;
                    case "left": newX = Math.max(pacman.x - pacman.speed, 0); break;
                    case "right": newX = Math.min(pacman.x + pacman.speed, gameArea.width - pacman.width); break;
                    }

                    // Comprobar colisión con las paredes
                    var collision = false
                    for (var i = 0; i < wallRepeater.count; i++) {
                        var wall = wallRepeater.itemAt(i)
                        if (wall.x < newX + pacman.width &&
                                wall.x + wall.width > newX &&
                                wall.y < newY + pacman.height &&
                                wall.y + wall.height > newY) {
                            collision = true
                            break
                        }
                    }
                    if (!collision) {
                        pacman.x = newX
                        pacman.y = newY
                    }
                    pacman.mover=false
                    return

                    if (!collision) {
                        pacman.x = newX
                        pacman.y = newY
                    }else{
                        switch (pacman.direction) {
                        case "up": newY = Math.max(pacman.y - 1, 0); break;
                        case "down": newY = Math.min(pacman.y + 1, gameArea.height - pacman.height); break;
                        case "left": newX = Math.max(pacman.x - 1, 0); break;
                        case "right": newX = Math.min(pacman.x + 1, gameArea.width - pacman.width); break;
                        }
                        /*var collision2 = false
                        for (var i = 0; i < wallRepeater.count; i++) {
                            wall = wallRepeater.itemAt(i)
                            if (wall.x < newX + pacman.width &&
                                    wall.x + wall.width > newX &&
                                    wall.y < newY + pacman.height &&
                                    wall.y + wall.height > newY) {
                                collision2 = true
                                break
                            }
                        }
                        if(!collision2){
                            pacman.x = newX
                            pacman.y = newY
                        }*/
                        if(!collision){
                            pacman.x = newX
                            pacman.y = newY
                        }
                    }
                }
            }
            function morir(){
                pacman.vivo=false
            }
            function resucitar(){
                pacman.vivo=true
            }
        }
        Rectangle{
            id: fakePacman
            width: pacman.width
            height: pacman.height
            radius: width*0.5
            color: 'transparent'
            x: pacman.x
            y: pacman.y
            opacity: pacman.vivo?1.0:0.0
            property int sd: 1//1*(pacman.speed*0.025)
            Behavior on x{NumberAnimation{duration: 50}}
            Behavior on y{NumberAnimation{duration: 50}}
            Image{
                id: cara
                anchors.fill: parent
                source: app.fr+'/imgs/bruno_1.png'
                mirror: true
            }
        }

        //Punto
        Component{
            id: compPunto
            Rectangle {
                id: punto
                width: app.wc+1
                height: app.hc+1
                radius: width / 2
                color: "transparent"
                property var coord: []
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(app.aInsert.length===0){
                            app.aInsert.push(coord[0])
                            app.aInsert.push(coord[1])
                        }else{
                            addPared(app.aInsert[0], app.aInsert[1], coord[0]-app.aInsert[0], coord[1]-app.aInsert[1])
                            //app.aInsert.push(coord[0]-app.aInsert[0])
                            //app.aInsert.push(coord[1]-app.aInsert[1])
                            app.aInsert=[]
                        }

                        console.log('0 insert: '+app.aInsert.toString())
                    }
                }
                Rectangle {
                    id: puntoCentro
                    width: parent.width*0.3
                    height: width
                    radius: width / 2
                    color: "white"
                    anchors.centerIn: parent
                }

                /*property int gridX: index % app.wc
                property int gridY: Math.floor(index / app.hc)

                x: app.cantCellH + gridX * app.wc
                y: app.cantCellV + gridY * app.hc*/

                visible: true

                Timer {
                    interval: 16
                    running: true
                    repeat: true
                    onTriggered: {
                        if (Math.abs(pacman.x - punto.x) < app.wc*0.8 && Math.abs((pacman.y) - punto.y) < app.wc*0.8) {
                            if(puntoCentro.visible){
                                app.puntos+=10
                                app.puntosComidos++
                                if(app.puntosComidos===app.puntosMax){
                                //if(app.puntosComidos===10){
                                    app.nivelCompletado=true
                                    loadPuntos()
                                    app.nivel++
                                    loadPantalla(app.nivel)
                                }
                                aCome.volume=1.0
                                aCome.play()
                            }
                            if(!puntoCentro.visible){
                                if(pacman.vivo){
                                    //aCome.volume=1.0
                                    //aCome.play()
                                }else{
                                    aCome.volume=0.2
                                    aCome.stop()
                                }
                            }else{
                                aCome.volume=0.2
                                aCome.stop()
                            }
                            puntoCentro.visible = false
                            pacman.x=punto.x//+app.wc*0.1
                            pacman.y=punto.y//+app.wc*0.1

                        }
                    }
                }
            }
        }

        //Fantasma
        Component{
            id: compFantasma
            // Pac-Man
            Rectangle {
                id: fantasma
                width: (app.width/app.cantCellH)-app.wc*0.2
                height: (app.height/app.cantCellV)-app.wc*0.2
                color: "transparent"
                border.width: 0
                border.color: 'green'
                //x: (app.width/app.cantCellH)*(app.cantCellH/2)//-2
                //y: ((app.height/app.cantCellV)*(app.cantCellV))//-2

                property int speed: app.wc//*0.25
                property string direction: "right"


                Timer {
                    id: moveTimerFantasma
                    interval: 100
                    running: !app.nivelCompletado
                    repeat: true
                    onTriggered: {
                        var newX = fantasma.x
                        var newY = fantasma.y

                        switch (fantasma.direction) {
                        case "up": newY = Math.max(fantasma.y - fantasma.speed, 0); break;
                        case "down": newY = Math.min(fantasma.y + fantasma.speed, gameArea.height - fantasma.height); break;
                        case "left": newX = Math.max(fantasma.x - fantasma.speed, 0); break;
                        case "right": newX = Math.min(fantasma.x + fantasma.speed, gameArea.width - fantasma.width); break;
                        }

                        // Comprobar colisión con las paredes
                        var collision = false
                        for (var i = 0; i < wallRepeater.count; i++) {
                            var wall = wallRepeater.itemAt(i)
                            if (wall.x < newX + fantasma.width &&
                                    wall.x + wall.width > newX &&
                                    wall.y < newY + fantasma.height &&
                                    wall.y + wall.height > newY) {
                                collision = true
                            }
                        }
                        var collision2=false
                        wall = pacman
                        if (wall.x < newX + fantasma.width &&
                                wall.x + wall.width > newX &&
                                wall.y < newY + fantasma.height &&
                                wall.y + wall.height > newY) {
                            collision2 = true
                        }
                        if(!collision){
                            fantasma.x = newX
                            fantasma.y = newY

                        }
                        if(collision2){
                            if(!app.dev)pacman.morir()
                            //Qt.quit()
                        }
                    }
                }
                Timer{
                    id: moveAuto
                    running: true
                    repeat: true
                    interval: 1000
                    onTriggered: {
                        let i=gTR(0.1, 2.0)
                        let d=gTD()
                        let nd="right"
                        if(d===2){
                            nd="down"
                        }
                        if(d===3){
                            nd="left"
                        }
                        if(d===4){
                            nd="up"
                        }
                        parent.direction=nd
                        interval=i*1000
                        //console.log('ni: '+interval)
                        //console.log('nd: '+nd)
                        //console.log('d: '+d)

                    }
                }
                Rectangle{
                    id: fakeFantasma
                    width: fantasma.width
                    height: fantasma.height
                    radius: width*0.5
                    color: 'transparent'
                    x: fantasma.x
                    y: fantasma.y
                    parent: gameArea
                    property int sd: 1//1*(pacman.speed*0.025)
                    Behavior on x{NumberAnimation{duration: 50}}
                    Behavior on y{NumberAnimation{duration: 50}}
                    Image{
                        id: caraFantasma
                        anchors.fill: parent
                        source: app.fr+'/imgs/fantasma_1.png'
                        //mirror: true
                    }
                }
                function gTR(min, max) {
                    return Math.random() * (max - min) + min;
                }
                function gTD() {
                    return parseInt(Math.random() * (5 - 1) + 1);
                }
            }
        }
        // Controles del teclado
        focus: true
        Keys.onPressed: {
            //if(!pacman.vivo)pacman.vivo=true
            pacman.mover=true
            switch (event.key) {
            case Qt.Key_Up: pacman.direction = "up"; setDir(0); break;
            case Qt.Key_Down: pacman.direction = "down"; setDir(3); break;
            case Qt.Key_Left: pacman.direction = "left"; setDir(2); break;
            case Qt.Key_Right: pacman.direction = "right"; setDir(1); break;
            }
        }
    }
    Rectangle{
        width: app.width
        height: app.hc
        color: 'transparent'
        anchors.top: parent.top
        Row{
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.centerIn: parent
            Text{
                text: 'Puntos:'+app.puntos+'    Nivel: '+app.nivel//app.wc+' HC:'+app.hc
                font.pixelSize: app.wc*0.5
                color: 'white'
                anchors.verticalCenter: parent.verticalCenter
            }
            Item{
                width: app.fs*3
                height: 1
            }
            Text{
                text: 'Comiste:'+app.puntosComidos+' de '+app.puntosMax
                font.pixelSize: app.wc*0.5
                color: 'white'
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    Rectangle{
        width: txtPuntos.contentWidth+app.fs
        height: txtPuntos.contentHeight+app.fs
        color: 'black'
        border.width: 12
        border.color: 'white'
        radius: app.fs*0.25
        opacity: !pacman.vivo&&app.puntos>=10?1.0:0.0
        anchors.centerIn: parent
        Text{
            id: txtPuntos
            text: 'Hiciste\n'+app.puntos+' puntos!'
            width: app.fs*20
            color: 'white'
            font.pixelSize: app.fs*3
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }
    Timer{
        id: tContinueEdit
        interval: 500
        onTriggered: app.dev=true
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: app.close()
    }
    Shortcut{
        sequence: 'Enter'
        onActivated: {
            reiniciar()
        }
    }
    Shortcut{
        sequence: 'Return'
        onActivated: {
            reiniciar()
        }
    }
    Shortcut{
        sequence: 'Space'
        onActivated: {
            if(Qt.platform.os!=='android'){
                app.aInsert=[]
                app.dev=!app.dev
            }else{
                reiniciar()
            }
        }
    }
    Shortcut{
        sequence: 'd'
        onActivated: {
            app.dev=!app.dev
        }
    }
    property var aInsert: []
    property bool insert: false
    onAInsertChanged:{
        if(app.aInsert.length>=4){
            //addPared(app.aInsert[0], app.aInsert[1], app.aInsert[2], app.aInsert[3])
            app.aInsert=[]
        }
    }
    Shortcut{
        sequence: 'i'
        onActivated: {
            app.aInsert=[]
            //if(!app.dev)return
            //app.insert=true
            //txtPuntos.text=aInsert.toString()
        }
    }
    Shortcut{
        sequence: 'v'
        onActivated: {
            app.visibility=app.visibility===ApplicationWindow.FullScreen?"Windowed":"FullScreen"
        }
    }
    Shortcut{
        sequence: 'Ctrl+Up'
        onActivated: {
            app.nivel++
        }
    }
    Timer{
        id: load
        running: true
        repeat: false
        interval: 1500
        onTriggered: {
            reiniciar()
        }
    }
    Component.onCompleted: {
        app.fr= Qt.platform.os==='android'?unik.getPath(4):unik.getPath(5)
        app.requestActivate()
    }
    function reiniciar(){
        if(pacman.vivo&&!app.dev)return
        loadPuntos()
        loadPantalla(app.nivel)
        pacman.resucitar()
        pacman.x= (app.width/app.cantCellH)*(app.cantCellH/2)
        pacman.y= ((app.height/app.cantCellV)*(app.cantCellV))
        pacman.direction="down"
        app.puntos=0
        app.nivel=1
    }
    function loadPuntos(){
        for(var i=0;i<xPuntos.children.length;i++){
            xPuntos.children[i].destroy(0)
        }
        for(i=0;i<app.cantCellH;i++){
            for(var i2=0;i2<app.cantCellV;i2++){
                let obj=compPunto.createObject(xPuntos, {x: i*app.wc, y: i2*app.hc, coord: [i, i2]})
            }
        }
    }
    function loadPantalla(nivel){
        let jd=unik.getFile(app.fr+'/pantalla_'+nivel+'.json')//.replace(/\n/g, '')
        //let jd=unik.getFile('/home/ns/nsp/qml-pacman/pantalla_'+2+'.json')//.replace(/\n/g, '')
        //console.log(jd)
        let j=!app.dev?JSON.parse(jd):app.tempJson
        app.tempJson=j
        let aPos=[]
        for(var i=0;i<Object.keys(j.paredes).length;i++){
            let e={c: j.paredes[i].c, x:j.paredes[i].x*app.wc, y:j.paredes[i].y*app.hc, width: j.paredes[i].width*app.wc, height: j.paredes[i].height*app.hc}
            if(app.nivel===1){
                e.c='blue'
            }else if(app.nivel===2){
                e.c='green'
            }else{
                e.c='red'
            }

            if(app.dev){
                e.c='red'
            }
            aPos.push(e)
            contarPuntajeMax()
        }
        //wallRepeater.model=j.paredes
        wallRepeater.model=aPos
        for(i=0;i<j.fantasmas.length;i++){
            let datoFantasma= j.fantasmas[i]
            let obj=compFantasma.createObject(xPuntos, {x: datoFantasma.x*app.wc, y: datoFantasma.y*app.hc})
        }
    }
    function setDir(d){
        if(d===0){
            cara.mirror=false
            cara.rotation=90
        }
        if(d===1){
            cara.mirror=true
            cara.rotation=0
        }
        if(d===2){
            cara.mirror=false
            cara.rotation=0
        }
        if(d===3){
            cara.mirror=false
            cara.rotation=-90
        }

    }

    function addPared(x, y, w, h){
        if(x<0 || y<1 || w<1 || h<1)return
        let jd=unik.getFile(app.fr+'/pantalla_'+app.nivel+'.json')
        let j=JSON.parse(jd)
        let obj= {}
        obj.c= "pink"
        obj.x= x
        obj.y= y
        obj.width= w+1
        obj.height= h+1
        j.paredes.push(obj)
        unik.setFile(app.fr+'/pantalla_'+app.nivel+'.json', JSON.stringify(j, null, 2))
        app.dev=true
        reiniciar()
        app.dev=true
        loadPantalla(app.nivel)
        app.dev=true
    }
    function contarPuntajeMax(){
        let jd=unik.getFile(app.fr+'/pantalla_'+app.nivel+'.json')
        let j=JSON.parse(jd)
        let sup=0
        for(var i=0;i<j.paredes.length;i++){
            let obj= j.paredes[i]
            let s=obj.width*obj.height
            sup+=s
        }
        console.log('Superficie ocupada: '+sup+' puntos.')
        let totalSup=app.cantCellH*app.cantCellV
        console.log('Superficie Total: '+totalSup+' puntos.')
        let cantPuntosAComer=totalSup-sup
        console.log('cantPuntosAComer: '+cantPuntosAComer+' puntos.')
        app.puntosMax=cantPuntosAComer
        app.puntosComidos=0
        app.nivelCompletado=false
    }
}
