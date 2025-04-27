import QtQuick 2.0
import QtQuick.Controls 2.0
import "../"

import ZoolText 1.1

Item {
    id: r
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
    property int padding:  8
    property int borderWidth: 1
    property color borderColor: 'red'
    property real borderRadius: 10.0
    property alias horizontalAlignment: txt.horizontalAlignment
    property alias verticalAlignment: txt.verticalAlignment
    property string labelText: ''
    property bool labelInTop: true
    property int w
    signal enterPressed
    width: xText.width//txt.contentWidth
    height: !r.labelInTop?xText.height:xText.height+labelTopTextInput.contentHeight

    Rectangle{
        id: xText
        //width: !r.w?r.parent.width-r.padding*2-r.borderWidth*2:r.w-r.padding*2-r.borderWidth*2
        width: !r.w?r.parent.width-r.borderWidth*2:r.w-r.borderWidth*2
        height: txt.contentHeight+r.padding*2+r.borderWidth*2//r.fs*1.2
        color: r.textBackgroundColor
        border.width: r.borderWidth
        border.color: r.borderColor
        radius: r.borderRadius
        anchors.centerIn: r
        clip: true
        TextInput{
            id: txt
            font.pixelSize: r.fs
            color: 'white'
            width: parent.width-r.padding*2
            wrapMode: TextInput.WordWrap
            horizontalAlignment: TextInput.Ali.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
            onTextChanged: {
                r.textChanged()
                txt.focus=true
            }
            Keys.onReturnPressed: r.returnPressed
            Keys.onEnterPressed:  r.returnPressed
        }
    }
    ZoolText {
        id: labelTopTextInput
        text: r.labelText
        width: xText.width
        w: xText.width
        font.pixelSize: app.fs*0.5
        color: 'white'
        anchors.bottom: xText.top
        visible: labelInTop
    }
}
