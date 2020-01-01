import QtQuick 2.6
import Nemo.Configuration 1.0

ConfigurationGroup {
    id: configuration

    path: "/apps/kraken"
    synchronous: true

    property string currency: "USD"
    property var homeTab: 0
    property string apiKey: ""
    property string apiSecret: ""
}
