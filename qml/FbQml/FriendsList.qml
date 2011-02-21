import QtQuick 1.0
import "JSonModelLoader.js" as Loader

Rectangle {

    property alias model: friendsView.model
    signal selected(string selectedId)

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
            id: delegateRect
            width: friendsList.width
            height: 50
            Image {
                id: buddyPic
                // accessToken is inherited from main.qml
                source: accessToken ? "https://graph.facebook.com/" + model.id + "/picture?" + accessToken : "nopic.gif"
            }

            Text {
                id: nameText
                text: name
                anchors.left: buddyPic.right
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.leftMargin: 10
                font.bold: true
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: statusText
                anchors.left: buddyPic.right
                anchors.top: nameText.bottom
                anchors.right: parent.right
                wrapMode: Text.WordWrap
                height: delegateRect.height - nameText.height
                anchors.leftMargin: 10
                anchors.rightMargin: 5
                clip: true
                // Lazy loader for status messages
                text: {
                    if (statusMessage == "") {
                        function createLoaderCallback() {
                            // The delegate might get destroyed before getting a response from
                            // the network. Thus, we must store the model and index into a
                            // closure function, which is then passed to the loadStatus callback.
                            var viewModel = friendsView.model;
                            var modelIndex = index;
                            return function(message) {
                                viewModel.setProperty(modelIndex, "statusMessage", message.replace(/[\r\n\t]/g, " "));
                            }
                        }

                        Loader.loadStatus(id, createLoaderCallback(), friendsView.model);
                    }
                    return statusMessage;
                }
            }

            states: State {
                name: "expanded"
                PropertyChanges {
                    target: delegateRect
                    height: nameText.height + statusText.paintedHeight
                }
            }

            transitions: Transition {
                NumberAnimation { target: delegateRect; property: "height"; duration: 200 }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (delegateRect.state == "") {
                        delegateRect.state = "expanded"
                    } else {
                        delegateRect.state = ""
                    }
                }
                drag.target: delegateRect
                drag.axis: Drag.XAxis
                drag.minimumX: 0 - parent.width
                drag.maximumX: parent.width

                // @TODO: Sometimes missed -> Stays where left
                onReleased: SmoothedAnimation {
                    target: delegateRect
                    property: "x"
                    to: 0
                    velocity: 500
                }
            }
        }
    }

    // Displays FB friends in list
    ListView {
        id: friendsView
        anchors.fill: parent
        anchors.margins: 5
        model: friendsModel
        delegate: friendDelegate
        spacing: 3

        // Prevent list elements from being drawn outside
        clip: true
    }
}
