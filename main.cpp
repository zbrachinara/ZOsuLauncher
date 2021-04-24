#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QThread>

#include <curl/curl.h>

#include "appmanager.h"
#include "interface.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    curl_global_init(CURL_GLOBAL_ALL);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    Interface interface(&engine);

    // PUT STUFF TO RUN BEFORE THE APP STARTS HERE

//    AppManager::init();
//    AppManager::check_updates();

    // END (PUT STUFF TO RUN ... HERE)

    int return_code = app.exec();

    AppManager::cleanup();
    curl_global_cleanup();

    return return_code;
}
