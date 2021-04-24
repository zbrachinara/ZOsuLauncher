#include "interface.h"
#include "appmanager.h"

Interface::Interface(QQmlApplicationEngine* engine, QObject* parent) : QObject(parent) {

    InterfaceWorker* worker = new InterfaceWorker();
    worker->moveToThread(&interface_thread);

    QObject* window = engine->rootObjects().first();
    QQuickItem* button_bar = window->findChild<QQuickItem*>("main_button_bar")->childItems().first();
    progress_bar = window->findChild<QQuickItem*>("progress_bar");

    qRegisterMetaType<curl_off_t>("curl_off_t");

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
                worker, SIGNAL(update_progress(curl_off_t, curl_off_t)),
                this, SLOT(update_progress(curl_off_t, curl_off_t))
    );

    QObject::connect(
                &interface_thread, SIGNAL(finished()),
                worker, SLOT(deleteLater())
    );

    interface_thread.start();

}

void Interface::update_progress(curl_off_t dltotal, curl_off_t dlnow) {
    qDebug() << "called Interface::update_progress(" << dltotal << "," << dlnow << ")";

    progress_bar->setProperty("full", (double) dlnow / (double) dltotal);
    progress_bar->setProperty("visible", !(dltotal == dlnow || dlnow == 0));
}

InterfaceWorker::InterfaceWorker(QObject* parent) : QObject(parent) {

}

void InterfaceWorker::update_callback(void* qobject, curl_off_t dltotal, curl_off_t dlnow, curl_off_t, curl_off_t) {

    emit static_cast<InterfaceWorker*>(qobject)->update_progress(dltotal, dlnow);

}

void InterfaceWorker::init() {

    AppManager::init(&InterfaceWorker::update_callback, this);

}

void InterfaceWorker::run_osu() {

    qDebug() << "placeholder for InterfaceWorker::run_osu()";

}

void InterfaceWorker::update() {

    qDebug() << "slot InterfaceWorker::update() activated";

    AppManager::check_updates();

}
