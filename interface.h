#ifndef INTERFACE_H
#define INTERFACE_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#include <QThread>

#include "appmanager.h"

class Interface : public QObject
{

    Q_OBJECT

public:
    explicit Interface(QQmlApplicationEngine*, QObject* = nullptr);

private:
    QThread interface_thread;
    QQuickItem* progress_bar;

};

class InterfaceWorker : public QObject
{

    Q_OBJECT

public:
    explicit InterfaceWorker(QObject* = nullptr);

private slots:
    static void run_osu(void);
    static void update(void);
    void init(void);


};

#endif // INTERFACE_H
