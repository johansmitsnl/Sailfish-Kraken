import QtQuick 2.4
import Sailfish.Silica 1.0

Item {

    property var pair: {name: "unkown"}
    property var rateDayLow: 0
    property var rateDayHigh: 0
    property var rate: 0
    property var color: ""


    x: Theme.horizontalPageMargin
    anchors.verticalCenter: parent.verticalCenter

    Row {

        spacing: Theme.horizontalPageMargin

        Label {
            text: percentageNow()
            color: Theme.primaryColor
        }

        Label {
            text: qsTr(pair.name)
            color: Theme.primaryColor
        }

    }

    function percentageNow() {
        return "0%"
    }
}
