import QtQuick 2.0
import QtQuick.Layouts 1.3

Rectangle {

    Layout.fillHeight: true
    Layout.fillWidth: true

    opacity: 0.9

    property alias buttonText: buttonText.text
    property var buttonAction: function() {
        console.log("No action specified")
    }

    Text {
        id: buttonText

        color: "white"
        font.family: "Aller"
        font.bold: true
        font.pointSize: 30

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent

        onClicked: {
            parent.buttonAction()
        }
    }

}
