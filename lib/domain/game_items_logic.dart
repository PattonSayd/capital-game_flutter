import 'dart:async';
import 'dart:math';

import 'package:capitals_quiz/domain/models.dart';

class GameItemsState {
  final int currentIndex;
  final List<GameItems> gameItems;

  const GameItemsState({
    required this.currentIndex,
    required this.gameItems,
  });

  static const empty = GameItemsState(currentIndex: 0, gameItems: []);

  GameItems get current => gameItems[currentIndex];

  GameItems? get next => ((currentIndex + 1) < gameItems.length)
      ? gameItems[currentIndex + 1]
      : null;

  bool get isCompleted => currentIndex == gameItems.length;

  bool get isCurrentTrue => current.fake == null;

  int get originalLength =>
      gameItems.where((element) => element.fake == null).length;

  int get fakeLength => gameItems.length - originalLength;

  double get progress => currentIndex / gameItems.length;

  GameItemsState copyWith({
    int? currentIndex,
    List<GameItems>? gameItems,
  }) {
    return GameItemsState(
      currentIndex: currentIndex ?? this.currentIndex,
      gameItems: gameItems ?? this.gameItems,
    );
  }
}

class GameItemsLogic {
  final Random _random;
  GameItemsLogic(this._random);

  var _state = GameItemsState.empty;

  GameItemsState get state => _state;

  final _controller = StreamController<GameItemsState>.broadcast();

  Stream<GameItemsState> get stream => _controller.stream;

  Future<void> dispose() => _controller.close();

  void updateCurrent(int current) =>
      _setState(state.copyWith(currentIndex: current));

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
    _setState(state.copyWith(gameItems: list));
  }

  void reset() {
    updateCurrent(0);
  }

  void _setState(GameItemsState state) {
    _state = state;
    _controller.add(_state);
  }
}
