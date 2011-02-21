#include "settingswriter.h"

SettingsWriter::SettingsWriter(QObject *parent) :
    QObject(parent), mSettings("Symbio", "QmlPluginExample")
{
}

void SettingsWriter::setName(const QString &name)
{
    if (name != mName) {
        mName = name;
        emit nameChanged(mName);
        QString val = mSettings.value(mName, QString("")).toString();
        setValue(val);
    }
}

QString SettingsWriter::name() const
{
    return mName;
}

void SettingsWriter::setValue(const QString &value)
{
    if (value != mValue) {
        mValue = value;
        qDebug(qPrintable("Value changed: " + mValue));
        emit valueChanged(mValue);
        if (!mName.isEmpty()) {
            if (mValue.isEmpty()) {
                mSettings.remove(mName);
            } else {
                mSettings.setValue(mName, mValue);
            }
        }
    }
}

QString SettingsWriter::value() const
{
    return mValue;
}
