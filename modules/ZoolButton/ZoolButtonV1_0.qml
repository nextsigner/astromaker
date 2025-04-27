import QtQuick 2.12
import QtQuick.Controls 2.12

Item{
    id: r
    width: btn.width
    height: btnText.contentHeight+(r.paddingWidth*2)
    property string text: '?'
    property int fs: app.fs*0.5
    property int paddingWidth: app.fs*0.25
    property bool colorInverted: false
    signal clicked
    Button{
        id: btn
        background: Rectangle {
            id: bg
            implicitWidth: btnText.contentWidth+r.paddingWidth
            implicitHeight: btnText.contentHeight+r.paddingWidth
            color: !r.colorInverted?apps.fontColor:apps.backgroundColor
            border.width: r.colorInverted ? 2 : 1
            border.color: r.colorInverted?apps.fontColor:apps.backgroundColor
            radius: app.fs*0.1
            Text{
                id: btnText
                text: r.text
                font.pixelSize: r.fs
                color: r.colorInverted?apps.fontColor:apps.backgroundColor
                anchors.centerIn: parent
            }
        }
        onClicked: {
            r.clicked()
        }
    }
}
