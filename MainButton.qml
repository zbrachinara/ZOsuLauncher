import QtQuick 2.0
import QtQuick.Layouts 1.3

Item {

    property alias buttonText: buttonText.text
    property var buttonAction: function() {
        console.log("No action specified")
    }
    property real space
    property alias back_opacity: background.opacity
    property alias front_opacity: body.opacity
    property alias color: body.color

    Layout.fillHeight: true
    Layout.fillWidth: true

    Rectangle {
        id: background
        opacity: 0.4

        anchors.fill: parent
        color: "black"
    }

    Rectangle {

        anchors {
            fill: parent
            leftMargin: space
            rightMargin: space
            topMargin: space
            bottomMargin: space
        }

        id: body

        opacity: 0.9
        radius: 10

        Text {
            id: buttonText

            color: "white"
            font.family: "Aller"
            font.bold: true
            font.pointSize: 20

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
            id: buttonArea
            anchors.fill: parent

            onClicked: {
                buttonAction()
            }
        }

    }

}
