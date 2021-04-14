import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewTest extends StatefulWidget {
  @override
  _WebviewTestState createState() => _WebviewTestState();
}

class _WebviewTestState extends State<WebviewTest> {
  late String html;
  late WebViewController webviewController;

  @override
  void initState() {
    String link =
        "https://ucertifylearn.page.link/?link=https://www.ucertify.com/?jhghjgjgj&apn=com.flutter.ucertifyLearn&isi=1505460373&ibi=com.flutter.ucertifyLearn";
    //  "intent://$link#Intent;scheme=https;package=com.flutter.ucertifyLearn;end"
    html = '''
    <html><body>
      <a href="intent://stackoverflow.com/questions/29250152/what-is-the-intent-to-launch-any-website-link-in-google-chrome#Intent;scheme=http;action=android.intent.action.VIEW;end;">click on link</a>
      <button type="button" onclick="window.location.replace('$link')">Click Me!</button>
      <a href="http://172.10.1.78:8888/pe-gold3/admin/test/test.php">localhost       </a>
      <a href="http://172.10.1.78:8888/pe-gold3/">localhost      222 </a>
      <a href="intent://scan/#Intent;scheme=zxing;package=com.google.zxing.client.android;S.browser_fallback_url=http%3A%2F%2Fzxing.org;end"> Take a QR code </a>
    </body></html>
    ''';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Webview"),
      ),
      body: Container(
        child: WebView(
          debuggingEnabled: false,
          //gestureNavigationEnabled: true,
          initialUrl:
              Uri.dataFromString(html, mimeType: 'text/html').toString(),
          // onPageFinished: (some) async {
          //   if (mounted) {
          //     webviewController.evaluateJavascript("""rangeDecoder();""");
          //   }
          // },
          onWebViewCreated: (_controller) {
            webviewController = _controller;
          },
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'getPostMessage',
                onMessageReceived: (JavascriptMessage message) {
                  print("message");
                }),
          ]),
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
