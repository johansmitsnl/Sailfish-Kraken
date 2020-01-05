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
            title: qsTr("Needs login")
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Login")
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/Credentials.qml"))
         }
    }

    // When credentials are set show the information needed
    Item {
        visible: functions.apiKeyPresent()
        id: mainColumn
        width: parent.width
        height: Screen.height

        PageHeader {
            id: currencyHeader
            title: qsTr("Balance") + " (" + settings.currency + ")"
        }

        PageHeader {
            id: totalBalanceHeader
            anchors.top: currencyHeader.bottom
            anchors.topMargin: 5

            title: functions.formatPrice(totalBalance)

        }

        SilicaListView {

            // Element values
            id: assetsListView
            height: parent.height
            anchors.top: totalBalanceHeader.bottom
            anchors.topMargin: 5
            width: parent.width

            model: assetsBalance
            visible: assetsBalance.length !== 0
            x: Theme.horizontalPageMargin

            delegate: BackgroundItem {
                id: delegate

                Column {
                    id: pairLabel

                    Row {
                        spacing: Theme.horizontalPageMargin


                        Text {
                            text: functions.formatPrice(assetsBalance[index].total)
                            font.pixelSize: Theme.fontSizeMediumBase
                            color: Theme.primaryColor
                            rightPadding: 20 * Theme.pixelRatio
                        }

                        Text {
                            text: functions.formatNumber(assetsBalance[index].balance)
                            font.pixelSize: Theme.fontSizeMediumBase
                            color: Theme.primaryColor
                            rightPadding: 20 * Theme.pixelRatio
                        }

                        Text {
                            text: assetsBalance[index].name
                            font.pixelSize: Theme.fontSizeMediumBase
                            color: Theme.primaryColor
                        }
                    }
                }

                Separator {
                    y: delegate.height
                    width: parent.width
                }
            }
            VerticalScrollDecorator {
            }
        }
    }



}
