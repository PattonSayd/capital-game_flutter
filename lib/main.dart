import 'dart:math';

import 'package:capitals_quiz/components.dart';
import 'package:capitals_quiz/game.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

const _appName = 'Quiz on  $countryLimit Capitals';

void main() => runApp(const App());

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with GameMixin<HomePage> {
  final TCardController _cardController = TCardController();

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (gameItems.isEmpty) {
      return const Center(
        child: Text('An error occurred, please try again'),
      );
    }

    return Scaffold(
      body: GradiientBackground(
        startColor: colors.main.withOpacity(0.3),
        endColor: colors.second.withOpacity(0.3),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ProgressWave(
                  color: colors.second.withOpacity(0.6),
                  progress: current / gameItems.length,
                  duration: const Duration(seconds: 15),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ProgressWave(
                  color: colors.main.withOpacity(0.4),
                  progress: max(0, score.toDouble()) / topScore,
                ),
              ),
              isCompleted
                  ? Positioned.fill(
                      child: CompletedWidget(
                        score: score,
                        topScore: topScore,
                        onTap: reset,
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(colors.second)),
                    ),
              if (!isCompleted)
                CenterLanscape(
                  child: LayoutBuilder(builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12)
                              .copyWith(top: 12),
                          child: Headers(
                            title: 'Is it ${gameItems[current].capital}?',
                            subtitle: gameItems[current].country,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TCard(
                            slideSpeed: 25,
                            delaySlideFor: 60,
                            controller: _cardController,
                            size: Size.square(min(
                              constraints.biggest.width,
                              constraints.biggest.height / 2,
                            )),
                            cards: gameItems
                                .map((e) =>
                                    CapitalCard(key: ValueKey(e), item: e))
                                .toList(),
                            onForward: (index, info) => onGuess(
                              index,
                              info.direction == SwipDirection.Right,
                              gameItems[current].fake != null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Controls(
                            onAnswer: (isTrue) => _cardController.forward(
                              direction: isTrue
                                  ? SwipDirection.Right
                                  : SwipDirection.Left,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
