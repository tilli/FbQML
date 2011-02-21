import QtQuick 1.0

Rectangle {

    signal clicked
    property alias text: submitText.text

    id: root
    width: submitText.paintedWidth + 30
    height: submitText.paintedHeight + 10
    border.color: "black"
    border.width: 1
    radius: 3

    Text {
        id: submitText
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked();
    }

    states: State {
        name: "pressed"
        when: mouseArea.pressed
        PropertyChanges {
            target: root
            color: "lightGray"
        }
    }
}
