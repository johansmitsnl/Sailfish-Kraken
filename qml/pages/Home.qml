import QtQuick 2.4
import Sailfish.Silica 1.0
import "../common"
import "../models"

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
                title: qsTr("Kraken (" + settings.currency + ") - (" + assetPrairs.length + ")")
            }
            delegate: BackgroundItem {
                id: delegate

                Label {
                    x: Theme.horizontalPageMargin
                    text: qsTr(assetPrairs[index].name)
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: console.log("Clicked " + index)
            }
            VerticalScrollDecorator {}
        }
    }

    function getData(url, callbackFunction) {
            var xmlhttp = new XMLHttpRequest();

            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
                    callbackFunction(xmlhttp.responseText)
                }
            }
            xmlhttp.open("GET", url, true);
            xmlhttp.send();
        }

    function refreshData() {
        console.debug("Reload the data from the API")
        getData("https://api.kraken.com/0/public/AssetPairs", refreshResult)
    }

    function refreshResult(data) {
        var assetPrairsResult = JSON.parse(data).result;
        var results = []
        for(var assetPrairKey in assetPrairsResult) {
            var assetPrair = assetPrairsResult[assetPrairKey]
            if(assetPrair.quote.indexOf(settings.currency) !== -1) {
                results.push({name: assetPrair.altname, quote: assetPrair.quote})
            }
        }

        assetPrairs = results
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
