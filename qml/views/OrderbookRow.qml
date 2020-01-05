import QtQuick 2.6
import Sailfish.Silica 1.0
import "../common"

Item {

    // Properties
    property var row: ({})

    // Element values
    width: parent.width
    x: Theme.horizontalPageMargin

    // Elements
    Functions {
        id: functions
    }

    Column {
        width: parent.width

        Row {
            width: parent.width
            spacing: Theme.horizontalPageMargin

            Text {
                text: functions.formatPrice(row.price, 5)
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                horizontalAlignment: Text.AlignRight
                width: parent.width / 4
            }

            Text {
                text: row.volume.toFixed(1)
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                horizontalAlignment: Text.AlignRight
                width: parent.width / 5
            }

            Text {
                text: functions.formatPrice(row.price * row.volume)
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                horizontalAlignment: Text.AlignRight
                width: parent.width / 4
            }
        }
    }
}
