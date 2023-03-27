import 'dart:math';

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
  final GameLogic game = GameLogic(Random(), const Api());
  final TCardController _cardController = TCardController();

  @override
  void initState() {
    super.initState();
    game.addListener(_update);
    onInit();
  }

  Future<void> onInit() async {
    await Assets.loadPictures();
    await game.onStartGame();
  }

  @override
  void dispose() {
    game.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  List<GameItem> get gameItems => game.gameItems;
  int get current => game.current;
  bool get isCompleted => game.isCompleted;
  ColorPair get colors => game.colors;
  int get score => game.score;
  int get topScore => game.topScore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradiientBackground(
        startColor: colors.main.withOpacity(0.3),
        endColor: colors.second.withOpacity(0.3),
        child: gameItems.isEmpty
            ? const SizedBox.shrink()
            : SafeArea(
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
                              onTap: () => game.onReset(),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(colors.second)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12)
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
                                      .map((e) => CapitalCard(
                                          key: ValueKey(e), item: e))
                                      .toList(),
                                  onForward: (index, info) => game.onGuess(
                                    index,
                                    info.direction == SwipDirection.Right,
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
