import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    id: root
    readonly property var db: LocalStorage.openDatabaseSync("main", "0.1", "Main Database", 100000);

    property var projectTable: Table {
        db: root.db
        name: 'some_table'
        scheme: ({
            key: { type: 'string'}
            value: { type: 'string'}
        })
    }
}
