import QtQuick 1.0

Rectangle {

    property string accessToken: ""
    property string message: ""

    id: myBar
    width: parent.width
    height: 50
    border.color: "black"
    border.width: 1
    anchors.margins: 3
    radius: 5

    // When FB log-in is complete, updates own picture
    onAccessTokenChanged: accessToken ? myPic.source = "https://graph.facebook.com/me/picture?" + accessToken : myPic.source = ""

    Image {
        id: myPic
        source: "nopic.gif"
        width: sourceSize.width > 0 ? sourceSize.height / sourceSize.width * height : parent.height
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: 3
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        id: rectangle2
        color: "white"
        anchors.left: myPic.right
        anchors.right: submitButton.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: 5
        Rectangle {
            color: "white"
            radius: 3
            border.color: "black"
            border.width: 1
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.fill: parent
            TextInput {
                id: myMessage
                text: ""
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                anchors.fill: parent
                anchors.rightMargin: 5
                anchors.leftMargin: 5
            }
        }
    }

    Button {
        id: submitButton
        text: "Submit"
        onClicked: myBar.message = myMessage.text
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
    }
}
