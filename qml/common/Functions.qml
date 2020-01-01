import QtQuick 2.0
import "."

Item {

    function getData(url, callbackFunction) {
        var xmlhttp = new XMLHttpRequest()

        var callBackEnabled = callbackFunction ? true : false

        if (callBackEnabled) {
            xmlhttp.onreadystatechange = function () {
                if (callbackFunction && xmlhttp.readyState === 4
                        && xmlhttp.status === 200) {
                    callbackFunction(xmlhttp.responseText)
                }
            }
        }
        xmlhttp.open("GET", url, (callbackFunction ? true : false))
        xmlhttp.send()

        if (!callBackEnabled) {
            if (xmlhttp.status === 200) {
                return (xmlhttp.responseText)
            } else {
                return false
            }
        }
    }

    function formatPrice(input, digets) {

        if(digets === undefined) {
            digets = 6
        }

        var length = Math.round(input).toString().length
        var fixedPrecision = (digets - length)
        if (fixedPrecision < 0) {
            fixedPrecision = 0
        }

        return currencySymbol() + input.toFixed(fixedPrecision)
    }

    function currencySymbol() {
        var result = ""
        switch (settings.currency) {
        case 'EUR':
            result = "€"
            break
        case 'USD':
            result = "$"
            break
        }
        return result
    }

    function apiKeyPresent() {
        return settings.apiKey !== "" && settings.apiSecret !== ""
    }

    Settings {
        id: settings
    }
}
