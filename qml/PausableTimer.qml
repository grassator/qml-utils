import QtQuick 2.0

Item {
    id: root
    property alias repeat: timer.repeat
    property alias running: timer.running
    property alias interval: timer.pausableInterval
    property alias triggeredOnStart: timer.triggeredOnStart

    signal triggered

    Timer {
        id: timer

        property int pausableInterval: 1000
        property real previousTimestamp: 0

        interval: pausableInterval
        onRunningChanged: {
            if(running) {
                previousTimestamp = new Date().getTime()
                return
            }

            var timeDifference = new Date().getTime() - previousTimestamp;

            if(timeDifference < interval) {
                interval = interval - timeDifference;
            }
        }

        onTriggered: {
            previousTimestamp = new Date().getTime()
            interval = pausableInterval
            root.triggered()
        }
    }
}
