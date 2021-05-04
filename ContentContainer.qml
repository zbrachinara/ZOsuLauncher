import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtWebEngine 1.8

Flickable {

    contentWidth: width
    contentHeight: stack.height

    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.OvershootBounds
    maximumFlickVelocity: 1000

    function push_settings() {
        stack.push(settings_top)
    }

    StackView {
        id: stack

        initialItem: changelog
        height: currentItem.height
        width: parent.width

    }

    Component {
        id: changelog

        Rectangle {

            id: content
            anchors.top: parent.top
            width: parent.width
            height: 1000

            WebEngineView {
                id: webview

//                anchors {
//                    left: parent.left
//                    right: parent.right
//                    top: buffer.bottom
//                }
                anchors.fill: parent

                focus: false
                activeFocusOnPress: false
                settings.showScrollBars: false
                url: "https://osu.ppy.sh/home/changelog/lazer"
                zoomFactor: 0.9

                onContentsSizeChanged: {
                    content.height = contentsSize.height
                }

            }

            Rectangle {
                anchors.fill: parent
                opacity: 0
            }
        }

    }

    Component {
        id: settings_top

        Rectangle {
            color: "white"

            id: content
            anchors.top: parent.top
            width: parent.width
            height:2000

            MainButton {

                id: back_button
                color: "#eeaa00"
                buttonText: "Back"
                height: 40

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: 5
                    rightMargin: 5
                    topMargin: 5
                }

                buttonAction: function() {
                    stack.pop()
                }

            }

            Text {

                anchors {
                    top: back_button.bottom
                    right: parent.right
                    left: parent.left

                    topMargin: 50
                }

                text: "
Thanks to ppy/osu-resources for backgrounds and icons
(under Creative Commons: https://github.com/ppy/osu-resources)

Also thanks to Qt for UI platform (https://www.qt.io)

This is 100% a work in progress

"
                horizontalAlignment: Text.AlignHCenter

            }


        }

    }

}
