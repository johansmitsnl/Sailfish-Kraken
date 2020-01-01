import QtQuick 2.6
import Sailfish.Silica 1.0

import "../common"

SilicaFlickable {
    anchors.fill: parent
    contentHeight: loginColumn.height + mainColumn.height

    Column {
        visible: !functions.apiKeyPresent()
        id: loginColumn
        width: parent.width

        PageHeader {
            title: qsTr("needs-login")
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTrId("login")
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/Credentials.qml"))
         }

    }

    Column {
        visible: functions.apiKeyPresent()
        id: mainColumn
        width: parent.width

        PageHeader {
            title: qsTr("balance") + " (" + settings.currency + ")"
        }

        SectionHeader {
            text: "Orderbook"
        }

    }
}
