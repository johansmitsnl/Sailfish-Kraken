import QtQuick 2.4
import Sailfish.Silica 1.0
import "../common"
import "../views"

Page {
    id: page

    property var assetPrairs: []

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Select USD")
                onClicked: setCurrency("USD")
            }
            MenuItem {
                text: qsTr("Select EUR")
                onClicked: setCurrency("EUR")
            }
            MenuItem {
                text: qsTr("Refresh now")
                onClicked: refreshData()
            }
        }

        SilicaListView {
            id: listView
            model: assetPrairs
            anchors.fill: parent
            header: PageHeader {
                title: qsTr("Kraken (" + settings.currency + ")")
            }
            delegate: BackgroundItem {
                id: delegate

                PairLabel {
                    x: Theme.horizontalPageMargin
                    pair: assetPrairs[index]
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: console.log("Clicked " + assetPrairs[index].key)
            }
            VerticalScrollDecorator {}
        }
    }

    function getData(url, callbackFunction) {
            var xmlhttp = new XMLHttpRequest();

            var callBackEnabled = callbackFunction ? true : false

        if(callBackEnabled) {
            xmlhttp.onreadystatechange=function() {
                if (callbackFunction && xmlhttp.readyState === 4 && xmlhttp.status === 200) {
                    callbackFunction(xmlhttp.responseText)
                }
            }
        }
        xmlhttp.open("GET", url, (callbackFunction ? true : false));
        xmlhttp.send();

        if(!callBackEnabled) {
            if (xmlhttp.status === 200) {
              return(xmlhttp.responseText);
            } else {
                return false;
            }
        }
    }

    function refreshData() {
        console.debug("Reload the data from the API")
        getData("https://api.kraken.com/0/public/AssetPairs", refreshResult)
    }

    function refreshResult(data) {
        const assetPrairsResult = JSON.parse(data).result;
        var results = []
        var pairQuery = []
        for(var assetPrairKey in assetPrairsResult) {
            const assetPrair = assetPrairsResult[assetPrairKey]
            if(assetPrair.quote.indexOf(settings.currency) !== -1 && assetPrair.wsname) {
                results.push({
                                 key: assetPrairKey,
                                 name: assetPrair.base,
                                 quote: assetPrair.quote,
                                 ticker: {
                                     opening: 0,
                                     low: 0,
                                     high: 0,
                                     ask: 0,
                                     bid: 0
                                 }
                             })
                pairQuery.push(assetPrairKey)
            }
        }

        // Collect all keys so that we can gather the ticker data
        const tickerUrl = "https://api.kraken.com/0/public/Ticker?pair=" + pairQuery.join(",")
        const tickerResult = getData(tickerUrl, false)
        if(tickerResult){
            const tickerData = JSON.parse(tickerResult).result
            for(var idx in results) {
                results[idx].ticker.opening = parseFloat(tickerData[results[idx].key].o)
                results[idx].ticker.low = parseFloat(tickerData[results[idx].key].l[0])
                results[idx].ticker.high = parseFloat(tickerData[results[idx].key].h[0])
                results[idx].ticker.ask = parseFloat(tickerData[results[idx].key].a[0])
                results[idx].ticker.bid = parseFloat(tickerData[results[idx].key].b[0])
            }

            // Save the results in the state
            assetPrairs = results
        } else {
            // Fixme Add loader error!
        }
    }

    function setCurrency(cur) {
        console.debug(cur)
        settings.currency = cur
        refreshData()
    }

    Settings {
        id: settings
    }

    Component.onCompleted: {
        if(assetPrairs.length === 0) {
            refreshData();
        }
    }
}
