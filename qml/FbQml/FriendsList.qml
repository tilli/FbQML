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

    // Prevent list elements from being drawn outside
    clip: true

    // A single list entry is handled by list deleagate
    // It displays friend name and fetches friend picture
    // using friends FB ID
    Component {
        id: friendDelegate
        Rectangle {
            id: delegateRect
            width: friendsList.width
            height: 50
            Item {
                id: detachableRect
                width: parent.width
                height: parent.height

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
            }

            MouseArea {
                height: parent.height
                width: buddyPic.width
                id: delegateMouseArea
                onPressed: friendsView.interactive = false
                onReleased: friendsView.interactive = true
            }

            states: State {
                name: "detached"
                when: delegateMouseArea.pressed

                // Center buddyPic horizontally
                PropertyChanges {
                    target: buddyPic
                    x: width > nameText.paintedWidth ? 0 : (nameText.paintedWidth - width) / 2
                }

                // Un-anchor and resize nameText
                AnchorChanges {
                    target: nameText
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.top: buddyPic.bottom
                    anchors.horizontalCenter: buddyPic.horizontalCenter
                }
                PropertyChanges {
                    target: nameText
                    width: paintedWidth
                }

                // Unanchor and hide statusText
                AnchorChanges {
                    target: statusText
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.top: undefined
                }
                PropertyChanges {
                    target: statusText
                    opacity: 0
                }

                // Fade the list
                PropertyChanges {
                    target: friendsView
                    opacity: 0.05
                }

                // Detach list item and move it to cursor position
                ParentChange {
                    target: detachableRect
                    parent: friendsList
                }
                PropertyChanges {
                    target: detachableRect
                    width: nameText.width > buddyPic.width ? nameText.width : buddyPic.width
                    x: friendsView.x + delegateRect.x + delegateMouseArea.mouseX - width / 2
                    y: delegateRect.y - friendsView.contentY + delegateMouseArea.mouseY + (friendsView.height - height) / 2
                }
            }

            transitions: [
                Transition {
                    from: ""; to: "detached"
                    ParentAnimation { NumberAnimation { properties: "x,y"; duration: 100 } }
                    AnchorAnimation { duration: 100 }
                    NumberAnimation { property: "opacity"; duration: 100 }
                },
                Transition {
                    from: "detached"; to: ""
                    ParentAnimation { SmoothedAnimation { properties: "x,y"; velocity: 600 } }
                    AnchorAnimation { duration: 200 }
                    NumberAnimation { property: "opacity"; duration: 200 }
                }
            ]
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
    }
}
