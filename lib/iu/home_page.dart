import 'dart:math';

import 'package:capitals_quiz/domain/game_items_logic.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

import '../domain/assemble.dart';
import '../domain/models.dart';
import 'components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TCardController _cardController = TCardController();
  final palette = assemble.palette;
  final gameItemsLogic = assemble.gameItemsLogic;
  final game = assemble.game;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  Future<void> onInit() async {
    await assemble.assets.loadPictures();
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
                    return const SizedBox.shrink();
                  }
                  return GradiientBackground(
                    startColor: colors.main.withOpacity(0.3),
                    endColor: colors.second.withOpacity(0.3),
                    child: SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: _ProgressWidget(),
                          ),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: _ScoreProgressWidget(),
                          ),
                          const _ResultOrLoadingWidget(),
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
                                      child: const _HeaderWidget(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: _CardsWidget(
                                        cardController: _cardController,
                                        constraints: constraints,
                                      ),
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

class _CardsWidget extends StatelessWidget {
  const _CardsWidget({
    Key? key,
    required this.cardController,
    required this.constraints,
  }) : super(key: key);

  final TCardController cardController;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameItemsState>(
        initialData: assemble.gameItemsLogic.state,
        stream: assemble.gameItemsLogic.stream,
        builder: (context, snapshot) {
          final state = snapshot.requireData;
          return TCard(
            slideSpeed: 25,
            delaySlideFor: 60,
            controller: cardController,
            size: Size.square(min(
              constraints.biggest.width,
              constraints.biggest.height / 2,
            )),
            cards: state.gameItems
                .map((e) => CapitalCard(key: ValueKey(e), item: e))
                .toList(),
            onForward: (index, info) {
              assemble.game.onGuess(
                index,
                info.direction == SwipDirection.Right,
              );
            },
          );
        });
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameItemsState>(
        initialData: assemble.gameItemsLogic.state,
        stream: assemble.gameItemsLogic.stream,
        builder: (context, snapshot) {
          final state = snapshot.requireData;
          return Headers(
            title: 'Is it ${state.current.capital}?',
            subtitle: state.current.country,
          );
        });
  }
}

class _ProgressWidget extends StatelessWidget {
  const _ProgressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        initialData: assemble.gameItemsLogic.state.progress,
        stream: assemble.gameItemsLogic.stream
            .map((state) => state.progress)
            .distinct(),
        builder: (context, snapshot) {
          final progress = snapshot.requireData;
          return StreamBuilder<Color>(
              initialData: assemble.palette.colors.second,
              stream: assemble.palette.stream
                  .map((state) => state.second)
                  .distinct(),
              builder: (context, snapshot) {
                final color = snapshot.requireData;
                return ProgressWave(
                    color: color.withOpacity(0.6),
                    progress: progress,
                    duration: const Duration(seconds: 15));
              });
        });
  }
}

class _ScoreProgressWidget extends StatelessWidget {
  const _ScoreProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: assemble.game.state.progress,
      stream: assemble.game.stream.map((state) => state.progress).distinct(),
      builder: (context, snapshot) {
        final progress = snapshot.requireData;
        return StreamBuilder<ColorPair>(
          initialData: assemble.palette.colors,
          stream: assemble.palette.stream,
          builder: (context, snapshot) {
            final colors = snapshot.requireData;
            return ProgressWave(
              color: colors.second.withOpacity(0.4),
              progress: progress,
              duration: const Duration(seconds: 15),
            );
          },
        );
      },
    );
  }
}

class _ResultOrLoadingWidget extends StatelessWidget {
  const _ResultOrLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameItemsState>(
      initialData: assemble.gameItemsLogic.state,
      stream: assemble.gameItemsLogic.stream,
      builder: (context, snapshot) {
        final isCompleted = snapshot.requireData.isCompleted;
        return isCompleted
            ? Positioned.fill(
                child: CompletedWidget(
                  score: assemble.game.state.score,
                  topScore: assemble.game.state.topScore,
                  onTap: () => assemble.game.onReset(),
                ),
              )
            : StreamBuilder<ColorPair>(
                initialData: assemble.palette.colors,
                stream: assemble.palette.stream,
                builder: (context, snapshot) {
                  final colors = snapshot.requireData;

                  return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(colors.second)),
                  );
                });
      },
    );
  }
}
