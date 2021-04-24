import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

ApplicationWindow {

    signal windowclose();

    onClosing: windowclose();

    id: z_osu_launcher
    width: 600
    height: 640
    visible: true
    title: qsTr("Hello World")

    color: "gray"

    Image {
        id: osu_background
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
        id: container
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
            border.color: "black"
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
        y: container.visibleArea.yPosition * container.height
        width: 10
        height: container.visibleArea.heightRatio * container.height

        color: "black"
        opacity: 0.5

    }

    Rectangle {

        id: button_bar_background

        color: "black"
        opacity: 0.4

        height: 80
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Rectangle {

        objectName: "main_button_bar"
        id: main_button_bar

        height: 80
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: "transparent";

        RowLayout {

            signal run_signal();
            signal update_signal();

            property real space: 5

            anchors.fill: parent;
            anchors.margins: space;
            id: actions

            spacing: space

            Button {

                objectName: "run_osu"

                id: launch
                color: "#6644cc"
                buttonText: "osu!"

                buttonAction: function() {
                    console.debug("sending signal run_signal()")
                    actions.run_signal()
                }
            }

            Button {

                objectName: "update_osu"

                id: update
                color: "#eeaa00"
                buttonText: "Check Updates"

                buttonAction: function() {
                    console.debug("sending signal update_signal()")
                    actions.update_signal()
                }

            }

        }

    }

    Rectangle {

        objectName: "progress_bar"
        id: progress_bar

        property real full: 0

        width: full * parent.width
        height: 10

        anchors.bottom: main_button_bar.top
        anchors.left: parent.left

        color: "yellow"
        opacity: button_bar_background.opacity

    }

}
