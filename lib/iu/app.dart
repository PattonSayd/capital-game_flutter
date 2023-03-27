import 'package:flutter/material.dart';

import '../domain/game.dart';
import 'components.dart';
import 'home_page.dart';

const _appName = 'Quiz on  ${GameLogic.countryLimit} Capitals';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: _appName,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => ThemeSwitcher(
          isDark: _dark,
          child: child,
          onToggle: () => setState(() => _dark = !_dark),
        ),
        theme: ThemeData(
          brightness: _dark ? Brightness.dark : Brightness.light,
        ),
        home: const HomePage(),
      );
}
