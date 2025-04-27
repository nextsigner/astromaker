import QtQuick 2.0
import QtQuick.Controls 2.0
//import "../"

Item {
    id: root
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
    property real textBackgroundOpacity: 1.0
    property int padding:  0
    property int borderWidth: 0
    property color borderColor: 'red'
    property real borderRadius: 0.0
    property alias textFormat: txt.textFormat
    property alias horizontalAlignment: txt.horizontalAlignment
    property alias verticalAlignment: txt.verticalAlignment
    Rectangle{
        id: xText
        width: txt.contentWidth+root.padding*2+root.borderWidth*2//txt.width
        height: txt.contentHeight+root.padding*2+root.borderWidth*2//root.fs*1.2
        color: root.textBackgroundColor
        border.width: root.borderWidth
        border.color: root.borderColor
        radius: root.borderRadius
        opacity: root.textBackgroundOpacity
        anchors.centerIn: r
    }
    Text {
        id: txt
        font.pixelSize: root.fs
        color: 'white'
        width: !root.w?txt.contentWidth:root.w
        textFormat: Text.RichText
        wrapMode: !root.w?Text.NoWrap:Text.WordWrap
        //horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: xText
    }
}
