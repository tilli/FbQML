import QtQuick 1.0

Rectangle {

    property alias model: friendsView.model

    id: friendsList
    color: "white"
    border.color: "black"
    border.width: 1
    anchors.margins: 3
    radius: 5

    // A single list entry is handled by list deleagate
    // It displays friend name and fetches friend picture
    // using friends FB ID
    Component {
        id: friendDelegate
        Rectangle {
            border.color: "black"
            border.width: 1
            width: friendsView.cellWidth
            height: friendsView.cellHeight
            Image {
                id: buddyPic
                anchors.fill: parent
                anchors.margins: 3
                // accessToken is inherited from main.qml
                source: accessToken ? "https://graph.facebook.com/" + model.id + "/picture?" + accessToken : "nopic.gif"
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    // Displays FB friends in grid
    GridView {
        id: friendsView
        cellWidth: friendsList.width / 6
        cellHeight: cellWidth
        anchors.fill: parent
        anchors.margins: 5
        model: friendsModel
        delegate: friendDelegate

        // Prevent list elements from being drawn outside
        clip: true
    }
}
