import QtQuick 2.6
import Sailfish.Silica 1.0

import "../common"

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: mainColumn.height

        Column {
            id: mainColumn
            width: parent.width

            PageHeader {
                title: qsTrId("credentials")
            }

            SectionHeader {
                text: qsTrId('api-key')
            }

            TextField {
                id: apiKeyInput

                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                placeholderText: qsTrId("enter-api-key")
                text: settings.apiKey
                width: parent.width

                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            }

            SectionHeader {
                text: qsTrId('api-secret')
            }

            PasswordField {
                id: apiSecretInput

                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                placeholderText: qsTrId("enter-api-secret")
                text: settings.apiSecret
                width: parent.width

                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTrId("save-credentials")
                onClicked: saveCredentials()
             }
        }
    }

    function saveCredentials() {
        console.debug("Save API credentials")
        settings.apiKey = apiKeyInput.text
        settings.apiSecret = apiSecretInput.text
    }

    Settings {
        id: settings
    }
}
