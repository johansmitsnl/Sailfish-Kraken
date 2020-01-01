import QtQuick 2.6
import Sailfish.Silica 1.0

import "../common"

SilicaFlickable {

    // Element values
    anchors.fill: parent
    contentHeight: loginColumn.height + mainColumn.height

    // Elements
    Functions {
        id: functions
    }

    Settings {
        id: settings
    }

    // When no credentials are set show that they are needed
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

    // When credentials are set show the information needed
    Column {
        visible: functions.apiKeyPresent()
        id: mainColumn
        width: parent.width

        PageHeader {
            title: qsTrId("balance") + " (" + settings.currency + ")"
        }

        SectionHeader {
            text: qsTrId("total")
        }

        Label {
            x: Theme.horizontalPageMargin
            text: functions.currencySymbol() + "100.00"
        }
    }

}
