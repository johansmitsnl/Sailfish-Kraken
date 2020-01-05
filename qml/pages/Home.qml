import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0
import "../common"
import "../views"

Page {

    // Properties
    property bool loading: false
    property var assetPrairs: []
    property var assetsBalance: []
    property var totalBalance: 0
    property var updatedAt: new Date()

    // Element values
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    id: page

    // Functions
    function changeTab(index) {
        settings.homeTab = index
        tabs.moveTo(index)
    }

    function refreshData() {
        console.debug("Refresh Asset pairs")
        loading = true
        krakenApi.queryPublic(['AssetPairs'], refreshResult)
    }

    function refreshResult(data) {
        var assetPrairsResult = data.result
        var results = []
        var pairQuery = []
        for (var assetPrairKey in assetPrairsResult) {
            var assetPrair = assetPrairsResult[assetPrairKey]
            if (assetPrair.quote.indexOf(settings.currency) !== -1
                    && assetPrair.wsname) {
                results.push({
                                 "key": assetPrairKey,
                                 "name": assetPrair.base,
                                 "quote": assetPrair.quote,
                                 "ticker": {
                                     "opening": 0,
                                     "low": 0,
                                     "high": 0,
                                     "ask": 0,
                                     "bid": 0,
                                     "current": 0,
                                     "last24": 0
                                 }
                             })
                pairQuery.push(assetPrairKey)
            }
        }

        // Collect all keys so that we can gather the ticker data
        //var tickerUrl = "https://api.kraken.com/0/public/Ticker?pair="
        var tickerResult = krakenApi.queryPublic(['Ticker', {pair: pairQuery.join(",")}])
        var tickerData = tickerResult.result
        for (var idx in results) {

            results[idx].ticker.opening = parseFloat(
                        tickerData[results[idx].key].o)
            results[idx].ticker.low = parseFloat(
                        tickerData[results[idx].key].l[0])
            results[idx].ticker.high = parseFloat(
                        tickerData[results[idx].key].h[0])
            results[idx].ticker.ask = parseFloat(
                        tickerData[results[idx].key].a[0])
            results[idx].ticker.bid = parseFloat(
                        tickerData[results[idx].key].b[0])
            results[idx].ticker.current = parseFloat(
                        tickerData[results[idx].key].c[0])
            results[idx].ticker.low24 = parseFloat(
                        tickerData[results[idx].key].l[1])
        }

        // Save the results in the state
        assetPrairs = results
        updatedAt = new Date()
        loading = false

        refreshBalanceData()
    }


    function refreshBalanceData() {
        console.debug("Refresh the balance data")
        krakenApi.queryPrivate(['Balance'], callbackBalanceData)
    }

    function callbackBalanceData(data) {
        //console.debug("Balance result returned")
        var balance = data.result
        var newTotalBalance = 0
        var newAssetsBalance = []
        //console.debug("result:", JSON.stringify(balance))
        for (var idx in assetPrairs) {
            //console.debug("idx", assetPrairs[idx].key)
            //console.debug("Parent values", JSON.stringify(assetPrairs[idx]))
            if(balance[assetPrairs[idx].name]) {
                //console.debug("Amount of key", assetPrairs[idx].key, parseFloat(balance[assetPrairs[idx].name]))
                var bal = parseFloat(balance[assetPrairs[idx].name])
                if(bal > 0) {
                    var assetTotal = bal * assetPrairs[idx].ticker.current
                    newTotalBalance += assetTotal
                    newAssetsBalance.push({
                                              name: assetPrairs[idx].name,
                                              balance: bal,
                                              total: assetTotal
                                          })
                }
            }
        }

        assetsBalance = newAssetsBalance
        totalBalance = newTotalBalance
    }

    function setCurrency(cur) {
        console.debug(cur)
        settings.currency = cur
        refreshData()
    }

    // Elements
    Functions {
        id: functions
    }

    KrakenApi {
        id: krakenApi
    }

    Settings {
        id: settings
    }

    Component.onCompleted: {
        if (assetPrairs.length === 0) {
            refreshData()
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: functions.apiKeyPresent() ? qsTr("Update credentials") : qsTr("Add credentials")
                onClicked: pageStack.push(Qt.resolvedUrl("Credentials.qml"))
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: refreshData()
            }
        }

        BusyIndicator {
            size: BusyIndicatorSize.Large
            anchors.centerIn: parent
            running: loading
        }

        TabView {
            id: tabs

            anchors.fill: parent
            currentIndex: settings.homeTab

            header: TabButtonRow {
                Repeater {
                    model: [qsTr("Market"), qsTr("Balance")]

                    TabButton {
                        onClicked: changeTab(model.index)

                        title: modelData
                        tabIndex: model.index
                    }
                }
            }

            model: [marketComponent, balanceComponent]
            Component {
                id: marketComponent
                Market {
                    id: marketView
                }
            }
            Component {
                id: balanceComponent
                Balance {
                    id: balanceView
                }
            }
        }
    }
}
