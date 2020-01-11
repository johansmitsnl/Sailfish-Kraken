import QtQuick 2.6
import Sailfish.Silica 1.0
import "../common"
import "../views"

Page {

    // Properties
    property var pair: ({})
    property var orderBookAsks: []
    property var orderBookBids: []
    property bool loading: false

    // Element values
    id: page
    allowedOrientations: Orientation.All

    // Functions
    function refreshData() {
        console.debug("Load orderbook")
        loading = true
        krakenApi.queryPublic(['Depth', {pair: pair.key}], refreshResult)
    }

    function refreshResult(data) {
        var OrderbookData = data.result
        var resultAsks = []
        var resultBids = []
        var asks = OrderbookData[pair.key].asks
        var bids = OrderbookData[pair.key].bids

        for (var askIdx in asks) {
            resultAsks.push({
                                "price": parseFloat(asks[askIdx][0]),
                                "volume": parseFloat(asks[askIdx][1])
                            })
        }

        for (var bidIdx in bids) {
            resultBids.push({
                                "price": parseFloat(bids[bidIdx][0]),
                                "volume": parseFloat(bids[bidIdx][1])
                            })
        }

        orderBookAsks = resultAsks
        orderBookBids = resultBids
        loading = false
    }

    Component.onCompleted: {
        refreshData()
    }

    // Elements

    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: loading
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: sellColumnView.height + mainColumn.height

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh now")
                onClicked: refreshData()
            }
        }

        Column {
            id: mainColumn
            width: parent.width

            PageHeader {
                title: pair.name + " (" + settings.currency + ")"
            }

            SectionHeader {
                text: "Orderbook"
            }
        }

        Column {
            id: buyColumn
            width: parent.width / 2
            y: mainColumn.height

            SectionHeader {
                text: "Buy"
            }
            ColumnView {
                id: buyColumnView
                width: parent.width
                itemHeight: Theme.itemSizeSmall

                model: orderBookBids
                delegate: BackgroundItem {
                    width: parent.width
                    OrderbookRow {
                        row: orderBookBids[model.index]
                    }
                }
            }
        }

        Column {
            id: sellColumn
            width: parent.width / 2
            x: parent.width / 2
            y: mainColumn.height

            SectionHeader {
                text: "Sell"
            }

            ColumnView {
                id: sellColumnView
                width: parent.width
                itemHeight: Theme.itemSizeSmall

                model: orderBookAsks
                delegate: BackgroundItem {
                    width: parent.width
                    OrderbookRow {
                        width: parent.width
                        row: orderBookAsks[model.index]
                    }
                }
            }
        }
    }
}
