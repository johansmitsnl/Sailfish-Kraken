import QtQuick 2.4
import Nemo.Configuration 1.0

ConfigurationGroup {
    id: configuration

    path: "/apps/kraken"
    synchronous: true

    property string currency: "USD"
}
