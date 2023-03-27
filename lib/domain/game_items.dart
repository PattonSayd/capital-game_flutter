import 'dart:math';

import 'package:capitals_quiz/domain/models.dart';

class GameItemsLogic {
  final Random _random;
  GameItemsLogic(this._random);

  var currentIndex = 0;

  final gameItems = <GameItems>[];

  GameItems get current => gameItems[currentIndex];

  GameItems? get next => ((currentIndex + 1) < gameItems.length)
      ? gameItems[currentIndex + 1]
      : null;

  bool get isCompleted => currentIndex == gameItems.length;

  bool get isCurrentTrue => gameItems[currentIndex].fake == null;

  int get originalLength =>
      gameItems.where((element) => element.fake == null).length;

  int get fakeLength => gameItems.length - originalLength;

  double get progress => currentIndex / gameItems.length;

  void updateCurrent(int current) => currentIndex = current;

  void updateGameItems(List<Country> countries) {
    final originals = countries.sublist(0, countries.length ~/ 2);
    final fakes = countries.sublist(countries.length ~/ 2, countries.length);
    fakes.shuffle(_random);
    final list = <GameItems>[];
    list.addAll(originals.map((e) => GameItems(original: e)));
    for (var i = 0; i < fakes.length; i++) {
      list.add(GameItems(
        original: fakes[i],
        fake: fakes[(i + 1) % fakes.length],
      ));
    }
    list.shuffle(_random);
    gameItems.clear();
    gameItems.addAll(list);
  }

  void reset() {
    updateCurrent(0);
  }
}
