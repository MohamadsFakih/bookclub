import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Readbook extends StatefulWidget {
  final String link;
  const Readbook({Key? key
  ,required this.link}) : super(key: key);

  @override
  State<Readbook> createState() => _ReadbookState();
}

class _ReadbookState extends State<Readbook> {
  @override
  Widget build(BuildContext context) {
    print(widget.link );
    return Scaffold(
      body: WebView(
        initialUrl: widget.link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
