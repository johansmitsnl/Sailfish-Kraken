import QtQuick 2.6
import Sailfish.Silica 1.0
import "../common"
import "../views"

Page {

    // Element values
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    id: page

    Component.onCompleted: {
        if (assetPrairs.length === 0) {
            refreshData()
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: functions.apiKeyPresent() ? qsTr("Update credentials") : qsTr("Add credentials")
                onClicked: pageStack.push(Qt.resolvedUrl("Credentials.qml"))
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: refreshData()
            }
        }

        BusyIndicator {
            size: BusyIndicatorSize.Large
            anchors.centerIn: parent
            running: loading
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            id: tabs
            y: Theme.paddingLarge


            Row {
                spacing: Theme.horizontalPageMargin

                Button {
                    text: qsTr("Market")
                    onClicked: changeTab('market')
                    down: settings.homeTab === 'market'
                }
                Button {
                    text: qsTr("Balance")
                    onClicked: changeTab('balance')
                    down: settings.homeTab === 'balance'
                }
            }
        }

        Market {
            id: market
            anchors.top: tabs.bottom
            anchors.topMargin: Theme.paddingLarge
            visible: settings.homeTab === 'market'
            clip: true
        }

        Balance {
            id: balance
            anchors.top: tabs.bottom
            anchors.topMargin: Theme.paddingLarge
            visible: settings.homeTab === 'balance'
            clip: true
        }

    }
}
