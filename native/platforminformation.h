#ifndef PLATFORMINFORMATION_H
#define PLATFORMINFORMATION_H

#include <QObject>
#include <QtQml>

class PlatformInformation : public QObject
{
    Q_OBJECT
    Q_PROPERTY (QString name READ name)
public:
    explicit PlatformInformation(QObject *parent = 0)
        : QObject(parent), m_platformName("Windows")
    {
#ifdef Q_OS_OSX
        m_platformName = "OSX";
#endif

#ifdef Q_OS_UNIX
        m_platformName = "Linux";
#endif
    }

    QString name() const { return m_platformName; }

private:
    QString m_platformName;

};

static QObject* platformInformationProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new PlatformInformation();
}

#endif // PLATFORMINFORMATION_H
