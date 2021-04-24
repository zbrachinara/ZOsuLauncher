#include "interface.h"
#include "appmanager.h"

Interface::Interface(QQmlApplicationEngine* engine, QObject* parent) : QObject(parent) {

    InterfaceWorker* worker = new InterfaceWorker(engine);
    worker->moveToThread(&interface_thread);

    QObject* window = engine->rootObjects().first();
    QQuickItem* button_bar = window->findChild<QQuickItem*>("main_button_bar")->childItems().first();
    progress_bar = window->findChild<QQuickItem*>("progress_bar");

    QObject::connect(
                &interface_thread, SIGNAL(started()),
                worker, SLOT(init())
    );

    QObject::connect(
                window, SIGNAL(windowclose()),
                &interface_thread, SLOT(quit())
    );

    QObject::connect(
                button_bar, SIGNAL(run_signal()),
                worker, SLOT(run_osu())
    );

    QObject::connect(
                button_bar, SIGNAL(update_signal()),
                worker, SLOT(update())
    );

    QObject::connect(
                &interface_thread, SIGNAL(finished()),
                worker, SLOT(deleteLater())
    );

    interface_thread.start();

}

InterfaceWorker::InterfaceWorker(QObject* parent) : QObject(parent) {

}

void InterfaceWorker::init() {

    AppManager::init();

}

void InterfaceWorker::run_osu() {

    qDebug() << "placeholder for InterfaceWorker::run_osu()";

}

void InterfaceWorker::update() {

    qDebug() << "slot InterfaceWorker::update() activated";

    AppManager::check_updates();

}
