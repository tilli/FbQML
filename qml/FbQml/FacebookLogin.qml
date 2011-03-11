import QtQuick 1.0
import QtWebKit 1.0

WebView {

    function startLogin() {
        opacity = 1;
        url = "https://graph.facebook.com/oauth/authorize?client_id=120278854704710&redirect_uri=http://www.facebook.com/connect/login_success.html&type=user_agent&display=popup&scope=read_stream";
        loginTimer.start();
    }

    function stopLogin(token) {
        opacity = 0;
        stop.trigger();
        url = "";
        loginTimer.stop();
        finished(token)
    }

    signal finished(string token)

    Behavior on opacity { NumberAnimation {} }

    id: webView
    opacity: 0
    anchors.fill: parent
    onLoadFinished: {
        console.debug("Auth response: " + url);
        var processed = false;
        var list = url.toString().split("#");
        if (list[0] == "http://www.facebook.com/connect/login_success.html") {
            stopLogin(list[1]);
            processed = true;
        } else {
            list = url.toString().split("?");
            if (list.length >= 2) {
                list = list[1].split("&");
                for (var elem in list) {
                    var tags = list[elem].split("=");
                    if (tags[0] == "error") {
                        stopLogin("");
                        processed = true;
                        break;
                    }
                }
            }
        }

        // Waiting for user, so stop timer
        if (!processed) {
            loginTimer.stop();
        }
    }

    Timer {
        id: loginTimer
        interval: 30000
        repeat: false
        onTriggered: {
            stopLogin("");
        }
    }

}
