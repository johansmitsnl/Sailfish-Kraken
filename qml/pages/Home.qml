import QtQuick 2.6
import Sailfish.Silica 1.0
import "../common"
import "../views"

Page {
    id: page

    property var assetPrairs: []
    property var loading: false

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh now")
                onClicked: refreshData()
            }
        }


        BusyIndicator {
            size: BusyIndicatorSize.Large
            anchors.centerIn: parent
            running: loading && assetPrairs.length === 0
        }


        SilicaListView {
            id: listView
            model: assetPrairs
            anchors.fill: parent
            visible: assetPrairs.length !== 0
            header: ComboBox {
                width: parent.width
                label: "Currenty"
                property var menuOptions: ["EUR", "USD"]

                currentIndex: menuOptions.indexOf(settings.currency)

                menu: ContextMenu {
                    MenuItem {
                        text: "EUR"
                        onClicked: setCurrency("EUR")
                    }
                    MenuItem {
                        text: "USD"
                        onClicked: setCurrency("USD")
                    }
                }
            }

            delegate: BackgroundItem {
                id: delegate
                implicitHeight: pairLabel.height + (100 * Theme.pixelRatio)

                PairLabel {
                    y: (5 * Theme.pixelRatio)
                    id: pairLabel
                    x: Theme.horizontalPageMargin
                    pair: assetPrairs[index]
                }

                Separator {
                    y: pairLabel.height
                    width: parent.width
                }

                onClicked: pageStack.push(Qt.resolvedUrl("PairDetails.qml"), {pair: assetPrairs[index]}) //console.log("Clicked " + assetPrairs[index].key)
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
        loading = true
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
                                     bid: 0,
                                     current: 0,
                                     last24: 0
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
                results[idx].ticker.current = parseFloat(tickerData[results[idx].key].c[0])
                results[idx].ticker.low24 = parseFloat(tickerData[results[idx].key].l[1])
            }

            // Save the results in the state
            assetPrairs = results
        } else {
            // Fixme Add loader error!
        }

        loading = false
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
