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
    title: qsTr("ZOsuLauncher")

    color: "gray"

    MainView {
        objectName: "main_view"
        id: main_view
    }

}
