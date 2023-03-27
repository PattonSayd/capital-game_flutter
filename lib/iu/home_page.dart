import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tcard/tcard.dart';

import 'package:capitals_quiz/domain/game.dart';
import 'package:capitals_quiz/domain/game_items_logic.dart';

import '../data/data.dart';
import '../domain/models.dart';
import 'components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cardController = TCardController();

  @override
  void initState() {
    super.initState();
    onInit();
  }

  Future<void> onInit() async {
    await context.read<Assets>().loadPictures();
    if (!mounted) return;
    context.read<GameLogic>().add(const OnStartGameEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameItemsState>(builder: (context, state, child) {
        if (state.gameItems.isEmpty) {
          return const SizedBox.shrink();
        }
        final isCompleted = state.isCompleted;
        return Consumer<ColorPair>(builder: (context, colors, child) {
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12)
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
    return Selector<GameItemsState, List<GameItems>>(
        selector: (context, state) => state.gameItems,
        builder: (context, gameItems, _) {
          return TCard(
            slideSpeed: 25,
            delaySlideFor: 60,
            controller: cardController,
            size: Size.square(min(
              constraints.biggest.width,
              constraints.biggest.height / 2,
            )),
            cards: gameItems
                .map((e) => CapitalCard(key: ValueKey(e), item: e))
                .toList(),
            onForward: (index, info) {
              context.read<GameLogic>().add(OnGuessGameEvent(
                    index: index,
                    isTrue: info.direction == SwipDirection.Right,
                  ));
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
    return Consumer<GameItemsState>(builder: (context, state, _) {
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
    return Selector2<GameItemsState, ColorPair, _ColoredProgressModel>(
        selector: (context, gameItemsState, colorPair) => _ColoredProgressModel(
            progress: gameItemsState.progress, color: colorPair.second),
        builder: (context, model, _) {
          return ProgressWave(
            color: model.color.withOpacity(0.6),
            progress: model.progress,
            duration: const Duration(seconds: 15),
          );
        });
  }
}

class _ScoreProgressWidget extends StatelessWidget {
  const _ScoreProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector2<GameState, ColorPair, _ColoredProgressModel>(
      selector: (context, gameState, colorPair) => _ColoredProgressModel(
          progress: gameState.progress, color: colorPair.main),
      builder: (context, model, _) {
        return ProgressWave(
          color: model.color.withOpacity(0.4),
          progress: model.progress,
          duration: const Duration(seconds: 15),
        );
      },
    );
  }
}

class _ResultOrLoadingWidget extends StatelessWidget {
  const _ResultOrLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        context.select<GameItemsState, bool>((state) => state.isCompleted);
    if (isCompleted) {
      final game = context.read<GameLogic>();
      return Positioned.fill(
        child: BlocBuilder<GameLogic, GameState>(
          builder: (context, state) {
            return CompletedWidget(
              score: state.score,
              topScore: state.topScore,
              onTap: () => game.add(const OnResetGameEvent()),
            );
          },
        ),
      );
    } else {
      return Consumer<ColorPair>(
        builder: (context, colors, _) {
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(colors.second)),
          );
        },
      );
    }
  }
}

class _ColoredProgressModel {
  final double progress;
  final Color color;
  const _ColoredProgressModel({
    required this.progress,
    required this.color,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ColoredProgressModel &&
        other.progress == progress &&
        other.color == color;
  }

  @override
  int get hashCode => progress.hashCode ^ color.hashCode;
}
