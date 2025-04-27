import QtQuick 2.12
import QtQuick.Controls 2.12

Item{
    id: r
    width: btn.width
    height: btnText.contentHeight+(r.paddingWidth*2)
    property string text: '?'
    property int fs: app.fs*0.5
    property int paddingWidth: app.fs*0.125
    property bool colorInverted: false
    signal clicked
    property bool pressed: false
    property alias borderWidth: bg.border.width
    property alias borderColor: bg.border.color
    Timer{
        id: tP
        running: r.pressed
        repeat: false
        interval: 250
        onTriggered: r.pressed=false
    }
    Button{
        id: btn
        background: Rectangle {
            id: bg
            implicitWidth: btnText.contentWidth+r.paddingWidth*2
            implicitHeight: btnText.contentHeight+r.paddingWidth*2
            height: btnText.contentHeight+r.paddingWidth*2
            color: !r.colorInverted?apps.fontColor:apps.backgroundColor
            border.width: r.borderWidth//r.colorInverted ? 2 : 1
            border.color: r.colorInverted?apps.fontColor:apps.backgroundColor
            radius: app.fs*0.1
            Text{
                id: btnText
                text: r.text
                font.family: "FontAwesome"
                font.pixelSize: !r.pressed?r.fs:r.fs*0.8
                color: r.colorInverted?apps.fontColor:apps.backgroundColor
                anchors.centerIn: parent
            }
        }
        onClicked: {
            r.pressed=true
            r.clicked()
        }
    }
}
