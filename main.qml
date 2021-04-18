import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3

Window {
    id: window
    width: 600
    height: 640
    visible: true
    title: qsTr("Hello World")

    color: "gray"

    Image {
        id: image
        source: "osu-resources/osu.Game.Resources/Textures/Menu/menu-background-1.jpg"
        fillMode: Image.PreserveAspectFit
        width: parent.width
    }

    Image {
        id: osu_button
        source: "osu-resources/osu.Game.Resources/Textures/Menu/logo.png"

        fillMode: Image.PreserveAspectFit
        width: 200

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 80

    }

    Flickable {
        id: flickable
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        contentWidth: content.width
        contentHeight: content.height + 200

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.OvershootBounds
        maximumFlickVelocity: 1000

        Rectangle {

            color: "gray"
            border.color:black
            border.width:5

            id: content
            anchors.top: parent.top
            anchors.topMargin: 200
            width: parent.parent.width
            height:1000

        }

    }

    Rectangle {
        id: scrollbar
        anchors.right: parent.right
        y: flickable.visibleArea.yPosition * flickable.height
        width: 10
        height: flickable.visibleArea.heightRatio * flickable.height

        color: "black"
        opacity: 0.5

    }

    RowLayout {
        id: actions
        height: 80
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        spacing: 0

        Button {
            id: launch
            color: "#6644cc"
        }

        Button {
            id: update
            color: "#eeaa00"
        }

    }

}
