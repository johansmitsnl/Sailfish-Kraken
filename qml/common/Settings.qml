import QtQuick 2.6
import Nemo.Configuration 1.0

ConfigurationGroup {

    // Properties
    property string currency: "USD"
    property var homeTab: 'market'
    property string apiKey: ""
    property string apiSecret: ""

    // Element values
    id: configuration
    path: "/apps/kraken"
}
