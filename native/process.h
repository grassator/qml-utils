#include <QProcess>
#include <QDebug>
#include <QtQml>

/**
 * @brief Simple Wrapper around QProcess for QML usage
 */
class Process : public QObject
{
    Q_OBJECT

public:
    explicit Process(QObject *parent = NULL) : QObject(parent) {
        m_process = new QProcess(this);
        m_process->setProcessEnvironment(QProcessEnvironment::systemEnvironment());
        connect(m_process, SIGNAL(started()), this, SIGNAL(started()));
        connect(m_process, SIGNAL(finished(int)), this, SIGNAL(finished(int)));
        connect(m_process, SIGNAL(readyReadStandardOutput()), this, SLOT(emitStandardOutput()));
        connect(m_process, SIGNAL(readyReadStandardError()), this, SLOT(emitStandardError()));
    }

    static void registerQmlType(const char *uri = "Native", int majorVersion = 1, int minorVersion = 0) {
        // @uri Native
        qmlRegisterType<Process>(uri, majorVersion, minorVersion, "Process");
    }

private slots:
    void emitStandardOutput() { emit standardOutput(m_process->readAllStandardOutput()); }
    void emitStandardError() { emit standardError(m_process->readAllStandardError()); }

public slots:
    void start(QString program, QStringList args = QStringList()) {
        m_process->start(program, args);
    }

    void kill() { m_process->kill(); }
    void terminate() { m_process->terminate(); }

signals:
    void started();
    void finished(int);
    void standardOutput(QString data);
    void standardError(QString data);

private:
    QProcess *m_process;

};
