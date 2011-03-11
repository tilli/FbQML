import QtQuick 1.0
import "JsonModelLoader.js" as Loader
import FacebookQML 1.0

Rectangle {
    id: rootRect
    width: 400
    height: 600

    property string accessToken: ""
    property bool settingsLoaded: false

    SettingsWriter {
        id: accessTokenStorage
        name: "AccessToken"
        value: rootRect.accessToken
        Component.onCompleted: {
            rootRect.accessToken = value
            rootRect.settingsLoaded = true;
        }
    }

    // When access token has been received via FB log-in,
    // the buddy model source URI is updated and it fetches
    // the buddy list from there
    onAccessTokenChanged: {
        if (accessToken) {
            friendsModel.clear();
            // Fetches the friends list after login has completed
            // and access token received from FB.
            // The query is JsonPath from http://goessner.net/articles/JsonPath/
            // Facebook API from http://developers.facebook.com/docs/api
            Loader.loadModel("https://graph.facebook.com/me/friends?" + accessToken, "/data",
                             function(element) {
                                 element.statusMessage = "";
                                 friendsModel.append(element);
                             });
        }
    }

    function loadRandomData() {
        // This adds random names into model.
        var firstNames = [ "Oliver", "Jack", "Harry", "Charlie", "Alfie", "Thomas", "Joshua", "William", "Daniel", "James" ]
        var lastNames = [ "Smith", "Jones", "Taylor", "Brown", "Williams", "Wilson", "Johnson", "Davis", "Robinson", "Wright" ]
        for (var i = 0; i < 50; i++) {
            var userName = firstNames[Math.round(Math.random() * (firstNames.length - 1))] + " " + lastNames[Math.round(Math.random() * (lastNames.length - 1))];
            var elem = {
                id: userName,
                name: userName,
                statusMessage: "Foobar Status"
            };
            friendsModel.append(elem);
        }
    }

    MyBar {
        id: myBar
        accessToken: rootRect.accessToken
        onMessageChanged: console.log("Submitted: " + message)
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
    }

    // Model for friends list
    ListModel {
        id: friendsModel
    }

    // List of friends
    FriendsList {
        id: friendsList
        model: friendsModel
        anchors.top: myBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttonBar.top
        opacity: rootRect.state == "" ? 1 : 0
        Behavior on opacity { NumberAnimation { } }
    }

    // Grid view of friends, just pictures
    FriendsGrid {
        id: friendsGrid
        model: friendsModel
        anchors.top: myBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttonBar.top
        opacity: rootRect.state == "grid" ? 1 : 0
        Behavior on opacity { NumberAnimation { } }
    }

    ButtonBar {
        id: buttonBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 40

        onClearTokenClicked: {
            accessToken = "";
            friendsModel.clear();
            login.startLogin();
        }

        onSwitchViewClicked: {
            if (rootRect.state == "") {
                rootRect.state = "grid";
            } else {
                rootRect.state = "";
            }
        }
    }

    states: State {
        name: "grid"
    }

    onSettingsLoadedChanged: {
        if (!accessToken) {
            console.log("Auth token not found from storage");
//            login.startLogin();
            loadRandomData();
        } else {
            console.log("Auth token loaded from storage: " + accessToken);
        }
    }

    // Logs into FB and updates accessToken property when ready
    // Z-order is higher than other components, so this gets shown
    // full-screen in case login is needed.
    FacebookLogin {
        id: login
        z: 1
        onFinished: {
            accessToken = token;
            if (!token) {
                loadRandomData();
            }
        }
    }

}
