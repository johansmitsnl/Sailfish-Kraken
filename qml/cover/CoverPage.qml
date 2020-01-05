import QtQuick 2.0
import Sailfish.Silica 1.0
import "../common"

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("My Cover")
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
        }
    }

    Functions {
        id: functions
    }
}
