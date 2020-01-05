#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include <QTranslator>
#include <QtDebug>

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/Kraken.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).


    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    QTranslator *appTranslator = new QTranslator;
    appTranslator->load("Kraken-" + QLocale::system().name(), SailfishApp::pathTo("translations").path());
    qDebug("Locale is: %s", QLocale::system().name().toLatin1().constData());
    app->installTranslator(appTranslator);

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/Kraken.qml"));
    view->setTitle("Kraken");
    view->showFullScreen();
    return app->exec();
}
