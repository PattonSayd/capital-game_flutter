import 'dart:math';

import 'package:capitals_quiz/domain/game_items_logic.dart';
import 'package:capitals_quiz/domain/palette.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

import '../data/data.dart';
import '../domain/game.dart';
import '../domain/models.dart';
import 'components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TCardController _cardController = TCardController();
  final random = Random();
  final assets = Assets();
  final palette = PaletteLogic();
  late final GameItemsLogic gameItemsLogic = GameItemsLogic(random);
  late final GameLogic game =
      GameLogic(random, const Api(), assets, palette, gameItemsLogic);

  @override
  void initState() {
    super.initState();
    onInit();
  }

  Future<void> onInit() async {
    await assets.loadPictures();
    await game.onStartGame();
  }

  @override
  void dispose() {
    gameItemsLogic.dispose();
    game.dispose();
    palette.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ColorPair>(
          initialData: palette.colors,
          stream: palette.stream,
          builder: (context, snapshot) {
            final colors = snapshot.requireData;
            return StreamBuilder<GameItemsState>(
                stream: gameItemsLogic.stream,
                builder: (context, snapshot) {
                  final isCompleted = gameItemsLogic.state.isCompleted;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.fromSize();
                  }
                  return GradiientBackground(
                    startColor: colors.main.withOpacity(0.3),
                    endColor: colors.second.withOpacity(0.3),
                    child: SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: StreamBuilder<GameItemsState>(
                                initialData: gameItemsLogic.state,
                                stream: gameItemsLogic.stream,
                                builder: (context, snapshot) {
                                  final progress =
                                      snapshot.requireData.progress;
                                  return ProgressWave(
                                    color: colors.main.withOpacity(0.4),
                                    progress: progress,
                                  );
                                }),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: StreamBuilder<GameState>(
                                initialData: game.state,
                                stream: game.stream,
                                builder: (context, snapshot) {
                                  final progress =
                                      snapshot.requireData.progress;
                                  return ProgressWave(
                                    color: colors.second.withOpacity(0.6),
                                    progress: progress,
                                    duration: const Duration(seconds: 15),
                                  );
                                }),
                          ),
                          StreamBuilder<GameItemsState>(
                              initialData: gameItemsLogic.state,
                              stream: gameItemsLogic.stream,
                              builder: (context, snapshot) {
                                final isCompleted =
                                    snapshot.requireData.isCompleted;
                                return isCompleted
                                    ? Positioned.fill(
                                        child: CompletedWidget(
                                          score: game.state.score,
                                          topScore: game.state.topScore,
                                          onTap: () => game.onReset(),
                                        ),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                colors.second)),
                                      );
                              }),
                          if (!isCompleted)
                            CenterLanscape(
                              child: LayoutBuilder(builder: (
                                BuildContext context,
                                BoxConstraints constraints,
                              ) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                              horizontal: 12)
                                          .copyWith(top: 12),
                                      child: StreamBuilder<GameItemsState>(
                                          initialData: gameItemsLogic.state,
                                          stream: gameItemsLogic.stream,
                                          builder: (context, snapshot) {
                                            final state = snapshot.requireData;
                                            return Headers(
                                              title:
                                                  'Is it ${state.current.capital}?',
                                              subtitle: state.current.country,
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: StreamBuilder<GameItemsState>(
                                          initialData: gameItemsLogic.state,
                                          stream: gameItemsLogic.stream,
                                          builder: (context, snapshot) {
                                            final state = snapshot.requireData;
                                            return TCard(
                                              slideSpeed: 25,
                                              delaySlideFor: 60,
                                              controller: _cardController,
                                              size: Size.square(min(
                                                constraints.biggest.width,
                                                constraints.biggest.height / 2,
                                              )),
                                              cards: state.gameItems
                                                  .map((e) => CapitalCard(
                                                      key: ValueKey(e),
                                                      item: e))
                                                  .toList(),
                                              onForward: (index, info) {
                                                game.onGuess(
                                                  index,
                                                  info.direction ==
                                                      SwipDirection.Right,
                                                );
                                              },
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Controls(
                                        onAnswer: (isTrue) =>
                                            _cardController.forward(
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
                  );
                });
          }),
    );
  }
}
