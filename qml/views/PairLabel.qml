import QtQuick 2.6
import Sailfish.Silica 1.0
import "../common"

Item {

    // Properties
    property var pair: ({
                            "name": "unkown",
                            "key": "unknown",
                            "ticker": {
                                "opening": 0,
                                "low": 0,
                                "high": 0,
                                "ask": 0,
                                "bid": 0
                            }
                        })
    // Element values
    x: Theme.horizontalPageMargin

    // Functions
    function ticker() {
        return pair.ticker
    }

    function currentPrice() {
        return ticker().current
    }

    function priceChange() {
        return (currentPrice() - ticker().low24)
    }

    function percentageNow() {
        return ((currentPrice() - ticker().low24) / ticker(
                    ).low24 * 100).toFixed(2)
    }

    // Elements
    Functions {
        id: functions
    }

    Column {

        Row {
            spacing: Theme.horizontalPageMargin

            Label {
                text: percentageNow() + "%"
                color: (percentageNow() > 0 ? "#00FF00" : "#FF0000")
                width: 100 * Theme.pixelRatio
            }

            Label {
                text: qsTr(pair.name)
                color: Theme.primaryColor
                width: 100 * Theme.pixelRatio
            }

            Label {
                text: functions.formatPrice(currentPrice())
                color: Theme.primaryColor
            }

            Label {
                text: ("(" + (priceChange(
                                  ) > 0 ? "+" : "") + functions.formatPrice(
                           priceChange()) + ")")
                color: (priceChange() > 0 ? "#00FF00" : "#FF0000")
                width: 100 * Theme.pixelRatio
            }
        }

        Row {
            spacing: Theme.horizontalPageMargin

            Text {
                text: qsTr("ticker-day-high") + ": " + functions.formatPrice(
                          pair.ticker.high)
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }

        Row {
            spacing: Theme.horizontalPageMargin

            Text {
                text: qsTr("ticker-day-low") + ": " + functions.formatPrice(
                          pair.ticker.low)
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }
}
