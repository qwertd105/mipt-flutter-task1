import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helper/app_state.dart';

class ArticleView extends StatefulWidget {
  final String blogUrl;

  const ArticleView({super.key, required this.blogUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  int loading = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loading = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loading = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loading = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.blogUrl),
      );
  }

  @override
  Widget build (BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("NewsPaper", style: TextStyle(color: Colors.orange, fontSize: 30),),
          Consumer<AppState>(
            builder: (context, appState, child) {
              return IconButton(onPressed: () {
                appState.toggleTheme();
              }, icon: Icon(appState.isDark ? Icons.sunny : Icons.nightlight_round));
            },
          )
        ],
      ),
      centerTitle: true,
      elevation: 0.0,
    ),
    body: Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loading < 100)
          LinearProgressIndicator(
            value: loading / 100.0,
          ),
      ],
    ),
  );
}