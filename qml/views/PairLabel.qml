import QtQuick 2.4
import Sailfish.Silica 1.0

Item {

    property var pair: ({name: "unkown", key: "unknown", ticker: {opening: 0, low: 0, high: 0, ask: 0, bid: 0}})

    x: Theme.horizontalPageMargin
    anchors.verticalCenter: parent.verticalCenter

    Row {

        spacing: Theme.horizontalPageMargin

        Label {
            text: percentageNow() + "%"
            color: (percentageNow() > 0 ? "#00FF00" : "#FF0000")
            width: 80 * Theme.pixelRatio
        }

        Label {
            text: ((priceChange() > 0 ? "+" : "") + formatPrice(priceChange()))
            color: (priceChange() > 0 ? "#00FF00" : "#FF0000")
            width: 100 * Theme.pixelRatio
        }

        Label {
            text: qsTr(pair.name)
            color: Theme.primaryColor
            width: 80 * Theme.pixelRatio
        }

        Label {
            text: formatPrice(pair.ticker.low)
            color: Theme.primaryColor
            width: 100 * Theme.pixelRatio
        }

        Label {
            text: formatPrice(pair.ticker.high)
            color: Theme.primaryColor
            width: 100 * Theme.pixelRatio
        }

    }

    function priceChange() {
        const ticker = pair.ticker
        return (((ticker.ask + ticker.bid) / 2) - ticker.opening)
    }

    function percentageNow() {
        const ticker = pair.ticker
        return (priceChange() / ticker.opening * 100).toFixed(2)
    }

    function formatPrice(input) {

        const length = Math.round(input).toString().length
        const fixedPrecision = (5 - length)
        if(fixedPrecision < 0) {
            fixedPrecision = 0
        }

        return input.toFixed(fixedPrecision)
    }
}
