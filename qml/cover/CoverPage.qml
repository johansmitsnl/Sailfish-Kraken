import QtQuick 2.0
import Sailfish.Silica 1.0
import "../common"
import "../pages"

CoverBackground {


    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: home.loading
    }

    Column {
        spacing: 40
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            topPadding: 30 * Theme.pixelRatio
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.highlightColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: Format.formatDate(home.updatedAt,
                                    Formatter.DurationElapsed);
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
            onTriggered: home.refreshData()
        }
    }

    Home {
        id: home
        visible: false
    }

    Functions {
        id: functions
    }
}
