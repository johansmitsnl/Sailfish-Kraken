import QtQuick 2.0
import Sailfish.Silica 1.0
import "../common"
import "../pages"

CoverBackground {
    id: cover

    property string _elapsedText

    function refreshElapsed() {
        _elapsedText = Format.formatDate(home.updatedAt, Formatter.DurationElapsed)
    }

    Timer {
        triggeredOnStart: true
        running: cover.status === Cover.Active
        interval: 60000
        repeat: true

        onTriggered: {
            refreshElapsed();
        }
    }

    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: home.loading
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.paddingLarge
        anchors.rightMargin: Theme.paddingLarge
        width: parent.width

        Label {
            topPadding: 30 * Theme.pixelRatio
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.highlightColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: _elapsedText
            visible: !home.loading
        }

        Label {
            id: labelTotalBalance
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.primaryColor
            text: functions.formatPrice(home.totalBalance)
            font.pixelSize: Theme.fontSizeLarge
            visible: !home.loading
            topPadding: 50 * Theme.pixelRatio
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                home.refreshData()
                refreshElapsed()
            }
        }
    }

    Home {
        id: home
        visible: false
    }

    Functions {
        id: functions
    }

    Component.onCompleted: {
        refreshElapsed();
    }
}
