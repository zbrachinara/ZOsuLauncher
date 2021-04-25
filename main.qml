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

    Image {
        id: settings_button
        source: "osu-resources/osu.Game.Resources/Textures/Icons/Hexacons/settings.png"

        fillMode: Image.PreserveAspectFit
        width: 30

        anchors {
            right: parent.right
            top: parent.top

            rightMargin: 10
            topMargin: 10
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                console.debug("settings button clicked")
                container.push_settings()
            }

        }
    }

    // start main content

    ContentContainer {
        id: container
        anchors {
            fill: parent
            topMargin: 200
        }
    }

    // end main content

    Rectangle {
        id: scrollbar
        anchors.right: parent.right
        y: container.visibleArea.yPosition * parent.height
        height: container.visibleArea.heightRatio * parent.height
        width: 5

        color: "black"
        opacity: 0.4

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

            anchors.fill: parent;
            anchors.margins: space;
            id: actions

            spacing: 0

            MainButton {

                objectName: "run_osu"

                id: launch
                color: "#6644cc"
                buttonText: "osu!"
                space: 5

                buttonAction: function() {
                    console.debug("sending signal run_signal()")
                    actions.run_signal()
                }
            }

            MainButton {

                objectName: "update_osu"

                id: update
                color: "#eeaa00"
                buttonText: "Check Updates"
                space: 5

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
