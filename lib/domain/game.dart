import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:capitals_quiz/data/data.dart';
import 'package:capitals_quiz/domain/game_items_logic.dart';
import 'package:capitals_quiz/domain/models.dart';
import 'package:capitals_quiz/domain/palette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameState {
  final int score;
  final int topScore;

  const GameState({required this.score, required this.topScore});

  static const GameState empty = GameState(score: 0, topScore: 1);

  double get progress => max(0, score) / topScore;

  GameState copyWith({
    int? score,
    int? topScore,
  }) {
    return GameState(
      score: score ?? this.score,
      topScore: topScore ?? this.topScore,
    );
  }
}

class GameLogic extends Cubit<GameState> {
  final Random _random;
  final Api _api;
  final Assets _assets;
  final PaletteLogic _palette;
  final GameItemsLogic _gameItemsLogic;

  GameLogic(
    this._random,
    this._api,
    this._assets,
    this._palette,
    this._gameItemsLogic,
  ) : super(GameState.empty);

  static const _successGuess = 3;
  static const _successFake = 1;
  static const _fail = -1;
  static const countryLimit = 20;

  List<Country>? _allCountries;

  Future<void> onStartGame() async {
    try {
      var countries = _allCountries ??= await _api.fetchCountries();
      countries.shuffle(_random);
      countries = countries.sublist(0, countryLimit);
      countries = _mergeCountryWithImages(countries);
      _prepareItems(countries);
    } catch (e) {
      debugPrint(e.toString());
    }
    _onUpdatePalette();
  }

  void _prepareItems(List<Country> countries) {
    _gameItemsLogic.updateGameItems(countries);
    final originals = _gameItemsLogic.state.originalLength;
    final fakes = _gameItemsLogic.state.fakeLength;
    final topScore = originals * _successGuess + fakes * _successFake;
    _updateTopScore(topScore);
  }

  void _onUpdatePalette() => _palette.updatePalette(
      _gameItemsLogic.state.current.image, _gameItemsLogic.state.next?.image);

  void _updateTopScore(int topScore) =>
      emit(state.copyWith(topScore: topScore));

  void _updateScore(int score) => emit(state.copyWith(score: score));

  void onGuess(int index, bool isTrue) {
    final isActuallyTrue = _gameItemsLogic.state.isCurrentTrue;
    int scoreUpdate = 0;

    if (isTrue && isActuallyTrue) {
      scoreUpdate = _successGuess;
    }

    if (!isTrue && !isActuallyTrue) {
      scoreUpdate = _successFake;
    }

    if (isTrue && !isActuallyTrue || !isTrue && isActuallyTrue) {
      scoreUpdate = _fail;
    }

    _updateScore(state.score + scoreUpdate);
    _gameItemsLogic.updateCurrent(index);

    if (!_gameItemsLogic.state.isCompleted) {
      _onUpdatePalette();
    }

    debugPrint(
        'Score: ${state.score}/${state.topScore}. Card: ${_gameItemsLogic.state.currentIndex}/${_gameItemsLogic.state.gameItems.length}');
  }

  List<Country> _mergeCountryWithImages(List<Country> countries) {
    return countries.where((e) {
      return e.capital.isNotEmpty;
    }).map((e) {
      final imageUrls = _assets.getPictures(e.capital);
      if (imageUrls.isNotEmpty) {
        final randomIndex = _random.nextInt(imageUrls.length);
        return Country(e.name, e.capital,
            imageUrls: imageUrls, index: randomIndex);
      } else {
        return Country(e.name, e.capital, imageUrls: imageUrls, index: -1);
      }
    }).where((e) {
      return e.index != -1;
    }).toList();
  }

  Future<void> onReset() async {
    _updateScore(0);
    _updateTopScore(1);
    _gameItemsLogic.reset();
    await onStartGame();
  }
}
