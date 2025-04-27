import QtQuick 2.0
import QtQuick.Controls 2.0
//import "../"

Item {
    id: r
    width: xText.width
    height: xText.height
    property int w//: txt.width
    property alias text: txt.text
    property alias t: txt
    property alias r: xText
    property alias font: txt.font
    property alias color: txt.color
    property alias contentWidth: txt.contentWidth
    property alias contentHeight: txt.contentHeight
    property alias wrapMode: txt.wrapMode
    property int fs: app.fs
    property color textBackgroundColor: 'transparent'
    property int padding:  0
    property int borderWidth: 0
    property color borderColor: 'red'
    property real borderRadius: 0.0
    property alias textFormat: txt.textFormat
    property alias horizontalAlignment: txt.horizontalAlignment
    property alias verticalAlignment: txt.verticalAlignment
    Rectangle{
        id: xText
        width: txt.contentWidth+r.padding*2+r.borderWidth*2//txt.width
        height: txt.contentHeight+r.padding*2+r.borderWidth*2//r.fs*1.2
        color: r.textBackgroundColor
        border.width: r.borderWidth
        border.color: r.borderColor
        radius: r.borderRadius
        anchors.centerIn: r
        Text {
            id: txt
            font.pixelSize: r.fs
            color: 'white'
            width: !r.w?contentWidth:r.w
            textFormat: Text.RichText
            wrapMode: !r.w?Text.NoWrap:Text.WordWrap
            //horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
        }
    }
}
