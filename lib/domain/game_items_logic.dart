import 'dart:math';

import 'package:capitals_quiz/domain/state/game_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/country.dart';
import 'models/game_items.dart';

class GameItemsLogic extends Cubit<GameItemsState> {
  final Random _random;
  GameItemsLogic(this._random) : super(GameItemsState.empty);

  void updateCurrent(int current) =>
      emit(state.copyWith(currentIndex: current));

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
    emit(state.copyWith(gameItems: list));
  }

  void reset() {
    updateCurrent(0);
  }
}
