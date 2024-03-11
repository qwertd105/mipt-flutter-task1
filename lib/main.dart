import 'package:tsk1/helper/app_state.dart';
import 'package:tsk1/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helper/app_theme.dart';

void main() {
  runApp(
      ChangeNotifierProvider(create: (context) => AppState(),
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return MaterialApp(
        title: 'NewsPaper',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme(appState.isDark),
        home: const Home(),
      );
    },);
  }
// This widget is the root of your application.

}
