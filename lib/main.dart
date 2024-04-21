import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tsk1/core/app_state.dart';
import 'package:tsk1/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var favoutites = await Hive.openBox('favourites');
  favoutites.isNotEmpty;

  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'NewsPaper',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme(appState.isDark),
          home: const Home(),
        );
      },
    );
  }
// This widget is the root of your application.
}
