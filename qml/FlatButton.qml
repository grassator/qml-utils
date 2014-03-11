import QtQuick 2.0

Rectangle {
    id: root
    width: (label.width + paddingX * 2) | 1
    height: (label.height + paddingY * 2) | 1
    radius: 5
    border.width: 1

    property int paddingX: 15
    property int paddingY: 8
    property color defaultColor: '#999'
    property color hoverColor: '#08f'
    property alias text: label.text

    signal clicked;

    state: 'default'

    states: [
        State {
            name: "default"
            PropertyChanges {
                target: root
                border.color: defaultColor
            }
            PropertyChanges {
                target: label
                color: '#333'
            }
        },
        State {
            name: "hover"
            PropertyChanges {
                target: root
                border.color: hoverColor
            }
            PropertyChanges {
                target: label
                color: root.hoverColor
            }
        }
    ]

    Text {
        id: label
        font.family: "Helvetica, sans-serif"
        font.pixelSize: 12
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.state = 'hover'
        onExited: root.state = 'default'
        onClicked: root.clicked(mouse)
    }
}
