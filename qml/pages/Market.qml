import QtQuick 2.6
import Sailfish.Silica 1.0
import "../views"

SilicaListView {
    id: listView
    y: tabs.height
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
        implicitHeight: pairLabel.height + (120 * Theme.pixelRatio)

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
