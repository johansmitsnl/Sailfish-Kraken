import QtQuick 2.6
import Sailfish.Silica 1.0

import "../common"

Page {

    // Functions
    function saveCredentials() {
        console.debug("Save API credentials")
        settings.apiKey = apiKeyInput.text
        settings.apiSecret = apiSecretInput.text
    }

    // Elements
    Settings {
        id: settings
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: mainColumn.height

        Column {
            id: mainColumn
            width: parent.width

            PageHeader {
                title: qsTr("Credentials")
            }

            SectionHeader {
                text: qsTr('API key')
            }

            TextField {
                id: apiKeyInput

                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                placeholderText: qsTr("Enter API key")
                text: settings.apiKey
                width: parent.width

                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            }

            SectionHeader {
                text: qsTr('API secret')
            }

            PasswordField {
                id: apiSecretInput

                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                placeholderText: qsTr("Enter API secret")
                text: settings.apiSecret
                width: parent.width

                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Save credentials")
                onClicked: saveCredentials()
             }
        }
    }
}
