import QtQuick 2.6
import Sailfish.Silica 1.0

Item {

    property var pair: ({name: "unkown", key: "unknown", ticker: {opening: 0, low: 0, high: 0, ask: 0, bid: 0}})

    x: Theme.horizontalPageMargin

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
                text: formatPrice(currentPrice())
                color: Theme.primaryColor
            }

            Label {
                text: ("(" + (priceChange() > 0 ? "+" : "") + formatPrice(priceChange()) + ")")
                color: (priceChange() > 0 ? "#00FF00" : "#FF0000")
                width: 100 * Theme.pixelRatio
            }

        }

        Row {
            spacing: Theme.horizontalPageMargin

            Text {
                text: qsTr("ticker-day-high") + ": " + formatPrice(pair.ticker.high)
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }

        Row {
            spacing: Theme.horizontalPageMargin

            Text {
                text: qsTr("ticker-day-low") + ": " + formatPrice(pair.ticker.low)
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }

    function ticker() {
        return pair.ticker
    }

    function currentPrice() {
        return ticker().current
    }

    function priceChange() {
        return (currentPrice() - ticker().opening)
    }

    function percentageNow() {
        return ((currentPrice() - ticker().low24) / ticker().low24 * 100).toFixed(2)
    }

    function formatPrice(input) {

        const length = Math.round(input).toString().length
        const fixedPrecision = (6 - length)
        if(fixedPrecision < 0) {
            fixedPrecision = 0
        }

        return currencySymbol() + input.toFixed(fixedPrecision)
    }

    function currencySymbol() {
        var result = ""
        switch(settings.currency) {
        case 'EUR':
            result = "€"
            break;
        case 'USD':
            result = "$"
            break;
        }
        return result
    }
}
