import QtQuick 1.0

Rectangle {
    id: buttonBar
    signal clearTokenClicked
    signal switchViewClicked

    Button {
        anchors.right: viewButton.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "Login"
        onClicked: buttonBar.clearTokenClicked()
    }
    Button {
        id: viewButton
        anchors.right: quitButton.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "Switch view"
        onClicked: buttonBar.switchViewClicked()
    }
    Button {
        id: quitButton
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "Quit"
        onClicked: Qt.quit()
    }
}

