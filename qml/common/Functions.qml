import QtQuick 2.6
import io.thp.pyotherside 1.5
import "."

Item {

    // Functions
    function apiKeyPresent() {
        return settings.apiKey !== "" && settings.apiSecret !== ""
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

    function getData(inputUrl, callbackFunction) {
        console.debug("python test:", krakenApi.test())
        var xmlhttp = new XMLHttpRequest()
        var url = Qt.resolvedUrl(inputUrl)
        var path = url.match(/^https:\/\/.+(\/.+)/)[1]

        var callBackEnabled = callbackFunction ? true : false

        if (callBackEnabled) {
            xmlhttp.onreadystatechange = function () {
                if (callbackFunction && xmlhttp.readyState === 4
                        && xmlhttp.status === 200) {
                    callbackFunction(xmlhttp.responseText)
                }
            }
        }
        xmlhttp.open("GET", url.toString(), (callbackFunction ? true : false))
        xmlhttp.send()

        if (!callBackEnabled) {
            if (xmlhttp.status === 200) {
                return (xmlhttp.responseText)
            } else {
                return false
            }
        }
    }

    function getPrivateData(inputUrl, callbackFunction) {
        var xmlhttp = new XMLHttpRequest()
        var url = Qt.resolvedUrl(inputUrl)
        var path = url.match(/^https:\/\/.+(\/.+)/)[1]

        var callBackEnabled = callbackFunction ? true : false

        if (callBackEnabled) {
            xmlhttp.onreadystatechange = function () {
                if (callbackFunction && xmlhttp.readyState === 4
                        && xmlhttp.status === 200) {
                    callbackFunction(xmlhttp.responseText)
                }
            }
        }

        // API headers calculation
        // Create a signature for a request

        xmlhttp.setRequestHeader("API-Key", settings.apiKey)
        xmlhttp.setRequestHeader("API-Sign", settings.apiKey)

        xmlhttp.open("POST",  url.toString(), (callbackFunction ? true : false))
        xmlhttp.send()

        if (!callBackEnabled) {
            if (xmlhttp.status === 200) {
                return (xmlhttp.responseText)
            } else {
                return false
            }
        }
    }

    // Elements
    Settings {
        id: settings
    }

    Python {
        id: krakenApi

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));

            setHandler('progress', function(ratio) {
                dlprogress.value = ratio;
            });
            setHandler('finished', function(newvalue) {
                page.downloading = false;
                mainLabel.text = 'Color is ' + newvalue + '.';
            });

            addImportPath('/usr/share/Kraken/lib/python');
            importModule_sync('KrakenApi', function () {});

        }

        function test() {
            return call_sync('KrakenApi.krakenapi.test', "")
        }


    }
}
