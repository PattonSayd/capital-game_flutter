import 'dart:async';
import 'dart:math';

import 'package:capitals_quiz/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:capitals_quiz/data/data.dart';
import 'package:capitals_quiz/domain/game_items_logic.dart';
import 'package:capitals_quiz/domain/models.dart';
import 'package:capitals_quiz/domain/palette.dart';

abstract class GameEvent {
  const GameEvent();
}

class OnStartGameEvent implements GameEvent {
  const OnStartGameEvent();
}

class OnResetGameEvent implements GameEvent {
  const OnResetGameEvent();
}

class OnGuessGameEvent implements GameEvent {
  final int index;
  final bool isTrue;
  const OnGuessGameEvent({
    required this.index,
    required this.isTrue,
  });
}

class GameState {
  final int score;
  final int topScore;
  final List<Country> countries;

  const GameState({
    required this.score,
    required this.topScore,
    required this.countries,
  });

  static const GameState empty =
      GameState(score: 0, topScore: 1, countries: []);

  double get progress => max(0, score) / topScore;

  GameState copyWith({
    int? score,
    int? topScore,
    List<Country>? countries,
  }) {
    return GameState(
      score: score ?? this.score,
      topScore: topScore ?? this.topScore,
      countries: countries ?? this.countries,
    );
  }
}

class GameLogic extends Bloc<GameEvent, GameState> {
  final Random _random;
  final Api _api;
  final Assets _assets;
  final PaletteLogic _palette;
  final GameItemsLogic _gameItemsLogic;
  final int countryLimit;

  GameLogic(
    this._random,
    this._api,
    this._assets,
    this._palette,
    this._gameItemsLogic, {
    this.countryLimit = GameLogic.defaultCountryLimit,
  }) : super(GameState.empty) {
    on<OnStartGameEvent>(_onStartGame);
    on<OnGuessGameEvent>(_onGuess);
    on<OnResetGameEvent>(_onReset);
  }

  static const _successGuess = 3;
  static const _successFake = 1;
  static const _fail = -1;
  static const defaultCountryLimit = 20;

  Future<void> _onStartGame(
    OnStartGameEvent event,
    Emitter<GameState> emit,
  ) async {
    var resultState = state;
    try {
      var countries = await _api.fetchCountries();
      countries = _mergeCountryWithImages(countries);
      resultState = resultState.copyWith(countries: [...countries]);
      final limitedCountries = _getCountriesForNewGame(countries);
      _gameItemsLogic.updateGameItems(limitedCountries);
      resultState = _prepareItems(resultState, limitedCountries);
    } catch (e, s) {
      logger.severe(e, s);
      debugPrint(e.toString());
    }
    await _updatePalette(_gameItemsLogic.state);
    emit(resultState);
  }

  List<Country> _getCountriesForNewGame(List<Country> countries) {
    final copyToShuffle = [...countries];
    copyToShuffle.shuffle(_random);
    return copyToShuffle.sublist(0, countryLimit);
  }

  GameState _prepareItems(GameState state, List<Country> countries) {
    _gameItemsLogic.updateGameItems(countries);
    final originals = _gameItemsLogic.state.originalLength;
    final fakes = _gameItemsLogic.state.fakeLength;
    final topScore = originals * _successGuess + fakes * _successFake;
    return _updateTopScore(state, topScore);
  }

  Future<void> _updatePalette(GameItemsState state) async =>
      _palette.updatePalette(state.current.image, state.next?.image);

  GameState _updateTopScore(GameState state, int topScore) =>
      state.copyWith(topScore: topScore);

  GameState _updateScore(GameState state, int score) =>
      state.copyWith(score: score);

  Future<void> _onGuess(
    OnGuessGameEvent event,
    Emitter<GameState> emit,
  ) async {
    final index = event.index;
    final isTrue = event.isTrue;
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

    final resultState = _updateScore(state, state.score + scoreUpdate);
    _gameItemsLogic.updateCurrent(index);

    final gameItemsState = _gameItemsLogic.state;
    if (!gameItemsState.isCompleted) {
      await _updatePalette(gameItemsState);
    }

    debugPrint(
        'Score: ${state.score}/${state.topScore}. Card: ${_gameItemsLogic.state.currentIndex}/${_gameItemsLogic.state.gameItems.length}');

    emit(resultState);
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

  void _onReset(
    OnResetGameEvent event,
    Emitter<GameState> emit,
  ) {
    _gameItemsLogic.reset();
    final limitedCountries = _getCountriesForNewGame(state.countries);
    _gameItemsLogic.updateGameItems(limitedCountries);
    final newState = _prepareItems(
      state.copyWith(score: 0),
      limitedCountries,
    );

    emit(newState);
  }

  @override
  void onTransition(Transition<GameEvent, GameState> transition) {
    super.onTransition(transition);
    logger.fine(
      'Bloc: ${transition.event.runtimeType}:'
      ' ${transition.currentState.score}/${transition.currentState.topScore} '
      '-> ${transition.nextState.score}/${transition.currentState.topScore}',
    );
  }
}
