import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class webView extends StatefulWidget {
  const webView ({Key? key}) : super(key: key);

  @override
  State<webView> createState() => _webViewState();
}

class _webViewState extends State<webView> {
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.apollopharmacy.in/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://www.apollopharmacy.in/'));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ptoton +",
      home: Scaffold(
        appBar: AppBar(
          title: Text("proton plus"),
        ),
        body: WebViewWidget(controller: controller),
    ),
    );
  }
}
