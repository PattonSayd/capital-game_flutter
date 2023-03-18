import 'dart:math';

import 'package:capitals_quiz/data/data.dart';
import 'package:capitals_quiz/domain/game_items.dart';
import 'package:capitals_quiz/domain/models.dart';
import 'package:capitals_quiz/domain/palette.dart';
import 'package:flutter/material.dart';

class GameLogic extends ChangeNotifier {
  final Random _random;
  final Api _api;
  final Assets _assets;
  final PaletteLogic _palette;
  final GameItemsLogic _itemsLogic;

  GameLogic(
    this._random,
    this._api,
    this._assets,
    this._palette,
    this._itemsLogic,
  );

  static const _successGuess = 3;
  static const _successFake = 1;
  static const _fail = -1;
  static const countryLimit = 20;

  int topScore = 0;
  int score = 0;

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
    _itemsLogic.updateGameItems(countries);
    final originals = _itemsLogic.originalLength;
    final fakes = _itemsLogic.fakeLength;
    _updateTopScore(topScore + originals * _successGuess);
    _updateTopScore(topScore + fakes * _successFake);
  }

  void _onUpdatePalette() => _palette.updatePalette(
      _itemsLogic.current.image, _itemsLogic.next?.image);

  void _updateTopScore(int topScore) => this.topScore = topScore;

  void _updateScore(int score) => _setState(() => this.score = score);

  void onGuess(int index, bool isTrue) {
    final isActuallyTrue = _itemsLogic.isCurrentTrue;
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

    _updateScore(score + scoreUpdate);
    _itemsLogic.updateCurrent(index);

    if (!_itemsLogic.isCompleted) {
      _onUpdatePalette();
    }

    debugPrint(
        'Score: $score/$topScore. Card: ${_itemsLogic.currentIndex}/${_itemsLogic.gameItems.length}');
  }

  List<Country> _mergeCountryWithImages(List<Country> countries) {
    return countries.where((e) {
      return e.capital != null;
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
    _updateTopScore(0);
    _itemsLogic.reset();
    await onStartGame();
  }

  void _setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
