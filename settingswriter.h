#ifndef SETTINGSWRITER_H
#define SETTINGSWRITER_H

#include <QObject>
#include <QSettings>

// SettingsWriter object is exported into QML
// When name property is changed, this loads the
// previously stored value from QSettings storage
// When value is changed, it is stored to QSettings
// using the name as key
class SettingsWriter : public QObject
{
    Q_OBJECT

    // Properties are exposed to QML runtime
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged);
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged);

public:
    explicit SettingsWriter(QObject *parent = 0);

    // Properties are mapped to READ and WRITE functions
    void setName(const QString &name);
    QString name() const;
    void setValue(const QString &value);
    QString value() const;

signals:
    // Changes are notified via property change signals.
    void nameChanged(const QString &name);
    void valueChanged(const QString &value);

public slots:
    // Slots are exposed to QML runtime as functions

private:
    // Private variables are used to filter away set-calls
    // that do not change anything
    QString mName;
    QString mValue;

    // QSettings stores name-value pairs into file system
    QSettings mSettings;
};

#endif // SETTINGSWRITER_H
