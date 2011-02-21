import QtQuick 1.0
import QtWebKit 1.0

WebView {

    function start() {
        opacity = 1;
        webView.url = "https://graph.facebook.com/oauth/authorize?client_id=120278854704710&redirect_uri=http://www.facebook.com/connect/login_success.html&type=user_agent&display=popup&scope=read_stream"
    }
    signal finished(string token)

    id: webView
    opacity: 0
    anchors.fill: parent
    onLoadFinished: {
        console.debug("Auth response: " + url);
        var list = url.toString().split("#");
        if (list[0] == "http://www.facebook.com/connect/login_success.html") {
            finished(list[1]);
        } else {
            list = url.toString().split("?");
            if (list.length >= 2) {
                list = list[1].split("&");
                for (var elem in list) {
                    var tags = list[elem].split("=");
                    if (tags[0] == "error") {
                        finished("")
                        break;
                    }
                }
            }
        }
    }
}
