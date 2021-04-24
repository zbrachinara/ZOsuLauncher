#ifndef INTERFACE_H
#define INTERFACE_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#include <QThread>
#include <QProcess>

#include "appmanager.h"

class Interface : public QObject
{

    Q_OBJECT

public:
    explicit Interface(QQmlApplicationEngine*, QObject* = nullptr);

private:
    QThread interface_thread;
    QQuickItem* progress_bar;

private slots:
    void update_progress(curl_off_t, curl_off_t);

};

class InterfaceWorker : public QObject
{

    Q_OBJECT

public:
    explicit InterfaceWorker(QObject* = nullptr);

private:
    static void update_callback(void*, curl_off_t, curl_off_t, curl_off_t, curl_off_t);

private slots:
    static void run_osu(void);
    static void update(void);
    void init(void);

signals:
    void update_progress(curl_off_t, curl_off_t);

};

#endif // INTERFACE_H
