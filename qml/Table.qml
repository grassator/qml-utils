import QtQuick 2.0

QtObject {
    id: root
    property var db;
    property var scheme: ({})
    property string name;
    property var model;
    property var modelComponent : Component {
        ListModel {
            property var table;
        }
    }

    function update(row) {
        console.log('update');
    }

    function remove(row) {
        db.transaction(function(tx){
            tx.executeSql('DELETE FROM ' + name + ' WHERE id=?', [row.id]);
        });
        model.remove(row.index, 1);
    }

    function refresh() {
        db.transaction(function(tx){
            var rs = tx.executeSql('SELECT * FROM ' + name + ' ORDER BY id DESC');
            var item;

            var newModel = modelComponent.createObject(null, {table: root});
            for(var i = 0; i < rs.rows.length; i++) {
                item = rs.rows.item(i);
                item.connectionCount = 0;
                newModel.append(item);
            }
            model = newModel;
        });
    }

    function insert(data) {
        var fieldNames = Object.keys(scheme);
        var sql = "INSERT INTO " + name +
                "(" + fieldNames.join(',') + ") "+
                " VALUES(" + fieldNames.map(function(){ return '?'; }) + ")";
        var res;

        db.transaction(function(tx){
            var values = [];
            for(var key in scheme) {
                var defaultValue = "defaultValue" in scheme[key] ?
                            scheme[key].defaultValue : null;
                values.push(key in data ? data[key] : defaultValue);
            }
            res = tx.executeSql(sql, values);
            if(res.insertId) {
                res = tx.executeSql('SELECT * FROM ' + name + ' WHERE id=?',
                                    [res.insertId]);
                if(res.rows.length) {
                    model.insert(0, res.rows.item(0));
                }
            } else {
                res = false;
            }
        });

        return res;
    }

    Component.onCompleted: {
        scheme.id = {
            "type": 'integer',
            "primary": true
        };

        // Initializing table if needed
        db.transaction(function(tx){
            var fields = [], field, type;
            for(var key in scheme) {
                field = key;
                type = scheme[key].type;
                if(type === 'string') {
                    type = 'text';
                }
                field += ' ' + type;
                if(scheme[key].primary) {
                    field += ' PRIMARY KEY ASC';
                }
                if(scheme[key].defaultValue) {
                    field += ' DEFAULT "' + scheme[key].defaultValue + '"';
                }
                fields.push(field);
            }
            fields.unshift(fields.pop()) // making id first fields

            var sql = 'CREATE TABLE IF NOT EXISTS ' + name + '(' + fields.join(',') +')';
            tx.executeSql(sql);
        });
        refresh();
    }
}
