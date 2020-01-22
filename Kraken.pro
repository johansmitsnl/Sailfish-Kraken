# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-kraken

CONFIG += sailfishapp

SOURCES += \
  src/harbour-kraken.cpp

HEADERS +=

DISTFILES += \
    harbour-kraken.desktop \
    qml/common/Functions.qml \
    lib/python/* \
    qml/common/KrakenApi.qml \
    qml/cover/CoverPage.qml \
    qml/harbour-kraken.qml \
    qml/views/Balance.qml \
    qml/pages/Credentials.qml \
    qml/pages/Home.qml \
    qml/views/Market.qml \
    qml/pages/PairDetails.qml \
    qml/views/OrderbookRow.qml \
    qml/views/PairLabel.qml \
    rpm/harbour-kraken.spec \
    rpm/harbour-kraken.changes.in \
    rpm/harbour-kraken.changes.run.in \
    rpm/harbour-kraken.yaml \
    translations/*.ts

lib_files.files = lib
lib_files.path = /usr/share/$$TARGET

INSTALLS += lib_files

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-kraken-nl_NL.ts \
    translations/harbour-kraken-zh_CN.ts
