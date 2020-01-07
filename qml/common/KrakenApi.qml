import QtQuick 2.6
import io.thp.pyotherside 1.5

Item {
    // Elements
    Settings {
        id: settings
    }

    Python {
        id: krakenApi

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));

            addImportPath('/usr/share/harbour-kraken/lib/python');
            importModule('KrakenApi', moduleLoadedSetKeys);

        }

        function moduleLoadedSetKeys() {
            console.debug("Python module KrakenApi loaded")
            call_sync('KrakenApi.api.set_keys', [settings.apiKey, settings.apiSecret])
        }

    }

    function queryPrivate(arguments, callback) {
        if(callback instanceof Function) {
            return krakenApi.call('KrakenApi.api.query_private', arguments, callback)
        } else {
            return krakenApi.call_sync('KrakenApi.api.query_private', arguments)
        }
    }

    function queryPublic(arguments, callback) {
        if(callback instanceof Function) {
            return krakenApi.call('KrakenApi.api.query_public', arguments, callback)
        } else {
            return krakenApi.call_sync('KrakenApi.api.query_public', arguments)
        }
    }

}
