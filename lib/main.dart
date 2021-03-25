import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dirPath;

  @override
  void initState() {
    setInit();
    super.initState();
  }

  setInit() async {
    String dPath = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      dirPath = dPath;
    });
  }

  Future<File> _downloadFile({String url, String filename}) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    File file = new File('$dirPath/$filename');
    await file.writeAsBytes(bytes);
    print("downloaded $filename");
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await _downloadFile(
                    url:
                        "https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css",
                    filename: "bootstrap.min.css");
                await _downloadFile(
                    url:
                        "https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js",
                    filename: "bootstrap.min.js");
                await _downloadFile(
                    url:
                        "https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js",
                    filename: "jquery.min.js");
              },
              child: SizedBox(
                  height: 50, width: 100, child: Text("download asset first")),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WebviewPage(dirPath)));
              },
              child: SizedBox(
                  height: 50, width: 100, child: Text("then Load Webview")),
            ),
          ],
        ),
      ),
    );
  }
}

class WebviewPage extends StatefulWidget {
  String dirPath;
  WebviewPage(this.dirPath);

  @override
  WebviewPageStete createState() => WebviewPageStete();
}

class WebviewPageStete extends State<WebviewPage> {
  String pageHtml = "";

  @override
  void initState() {
    pageHtml = """
    <!doctype html>
      <html>
        <head>
          <meta name="format-detection" content="telephone=no">
          <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
          <script type="text/javascript" src="jquery.min.js"></script>
          <script type="text/javascript" src="bootstrap.min.js"></script>
          <link href="bootstrap.min.css" rel="stylesheet" type="text/css"/>
        </head>
        <body>

          <div class="jumbotron text-center">
            <h1>My First Bootstrap Page</h1>
            <p>Resize this responsive page to see the effect!</p> 
          </div>
            
          <div class="container">
            <div class="row">
              <div class="col-sm-4">
                <h3>Column 1</h3>
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>
                <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>
              </div>
              <div class="col-sm-4">
                <h3>Column 2</h3>
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>
                <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>
              </div>
              <div class="col-sm-4">
                <h3>Column 3</h3>        
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>
                <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>
              </div>
            </div>
          </div>

          </body>
        </html>
          """;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Webview"),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: pageHtml,
          baseUrl: Uri.parse("file://${widget.dirPath}/"),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            minimumFontSize: 25,
            cacheEnabled: false,
            javaScriptEnabled: true,
            transparentBackground: true,
            verticalScrollBarEnabled: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            clearCache: true,
          ),
          android: AndroidInAppWebViewOptions(useHybridComposition: true),
          ios: IOSInAppWebViewOptions(
            allowingReadAccessTo: Uri.parse("file://${widget.dirPath}/"),
          ),
        ),
        onWebViewCreated: (webViewController) {
          webViewController.addJavaScriptHandler(
              handlerName: "getPostMessage", callback: (args) {});
        },
      ),
    );
  }
}
