#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>
#include "settingswriter.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<SettingsWriter>("FacebookQML", 1, 0, "SettingsWriter");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/FbQml/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
