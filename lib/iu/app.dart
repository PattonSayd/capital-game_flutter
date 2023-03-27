import 'package:capitals_quiz/domain/assemble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../domain/game.dart';
import 'components.dart';
import 'home_page.dart';

const _appName = 'Quiz on  ${GameLogic.defaultCountryLimit} Capitals';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          BlocProvider.value(value: assemble.game),
          Provider.value(value: assemble.assets),
          StreamProvider.value(
            value: assemble.gameItemsLogic.stream,
            initialData: assemble.gameItemsLogic.state,
          ),
          StreamProvider.value(
            value:
                assemble.palette.stream.map((event) => event.colors).distinct(),
            initialData: assemble.palette.colors,
          ),
          StreamProvider.value(
            value: assemble.game.stream,
            initialData: assemble.game.state,
          ),
        ],
        child: MaterialApp(
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
        ),
      );
}
