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
        : QObject(parent), m_platformName("unknown")
    {
#ifdef Q_OS_WIN
        m_platformName = "win32";
#endif
#ifdef Q_OS_FREEBSD
        m_platformName = "freebsd";
#endif
#ifdef Q_OS_DARWIN
        m_platformName = "darwin";
#endif
#ifdef Q_OS_DARWIN64
        m_platformName = "darwin";
#endif
#ifdef Q_OS_LINUX
        m_platformName = "linux";
#endif
#ifdef Q_OS_SOLARIS
        m_platformName = "sunos";
#endif
    }

    QString name() const { return m_platformName; }

    static void registerQmlSingleton(const char *uri = "Native", int majorVersion = 1, int minorVersion = 0) {
        // @uri Native
        qmlRegisterSingletonType<PlatformInformation>(uri,
                                                      majorVersion,
                                                      minorVersion,
                                                      "Platform",
                                                      platformInformationProvider);
    }

private:
    QString m_platformName;

    static QObject* platformInformationProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new PlatformInformation();
    }

};



#endif // PLATFORMINFORMATION_H
