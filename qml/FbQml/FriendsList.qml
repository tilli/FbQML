import QtQuick 1.0
import "JsonModelLoader.js" as Loader

Rectangle {

    property alias model: friendsView.model

    id: friendsList
    color: "white"
    border.color: "black"
    border.width: 1
    anchors.margins: 3
    radius: 5

    // Prevent list elements from being drawn outside
    clip: true

    // Displays FB friends in list
    ListView {
        id: friendsView
        anchors.fill: parent
        anchors.margins: 5
        model: friendsModel
        delegate: FriendDelegate {}
        spacing: 3
    }

    // Invisible item for list detach
    Item {
        id: detachParent
        anchors.fill: parent
        z: 1
    }
}
