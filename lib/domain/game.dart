import 'dart:math';

import 'package:capitals_quiz/data/data.dart';
import 'package:capitals_quiz/domain/models.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class GameLogic extends ChangeNotifier {
  final Random _random;
  final Api _api;

  GameLogic(this._random, this._api);

  static const _successGuess = 3;
  static const _successFake = 1;
  static const _fail = -1;
  static const countryLimit = 30;

  int topScore = 0;
  int score = 0;
  int current = 0;

  List<Country>? _allCountries;
  final gameItems = <GameItem>[];

  var colors = const ColorPair(Colors.grey, Colors.grey);

  PaletteGenerator? currentPalette;
  PaletteGenerator? nextPalette;

  bool get isCompleted => current == gameItems.length;

  Future<void> _onUpdatePalette() async {
    final crt = currentPalette == null
        ? await PaletteGenerator.fromImageProvider(gameItems[current].image)
        : nextPalette;
    final next = (current + 1) < gameItems.length
        ? await PaletteGenerator.fromImageProvider(gameItems[current + 1].image)
        : null;

    currentPalette = crt;
    nextPalette = next;
    colors = _buildColors(crt);
    _setState(() {});
  }

  ColorPair _buildColors(PaletteGenerator? palette) {
    Color? mainColor = currentPalette?.mutedColor?.color;
    Color? secondColor = currentPalette?.vibrantColor?.color;
    final defaultColor = mainColor ?? secondColor ?? Colors.grey;
    mainColor = mainColor ?? defaultColor;
    secondColor = secondColor ?? defaultColor;
    return ColorPair(mainColor, secondColor);
  }

  Future<void> onStartGame() async {
    try {
      var countries = _allCountries ??= await _api.fetchCountries();
      countries.shuffle(_random);
      countries = countries.sublist(0, countryLimit);
      countries = _mergeCountryWithImages(countries);
      _updateItems(countries);
    } catch (e) {
      debugPrint(e.toString());
    }
    await _onUpdatePalette();
  }

  List<Country> _mergeCountryWithImages(List<Country> countries) {
    return countries.where((e) {
      return e.capital != null;
    }).map((e) {
      final imageUrls = Assets.getPictures(e.capital);
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

  void _updateItems(List<Country> countries) {
    final originals = countries.sublist(0, countries.length ~/ 2);
    _updateTopScore(topScore + originals.length * _successGuess);
    final fakes = countries.sublist(countries.length ~/ 2, countries.length);
    _updateTopScore(topScore + fakes.length * _successFake);
    fakes.shuffle(_random);
    final list = <GameItem>[];
    list.addAll(originals.map((e) => GameItem(original: e)));
    for (var i = 0; i < fakes.length; i++) {
      list.add(GameItem(
        original: fakes[i],
        fake: fakes[(i + 1) % fakes.length],
      ));
    }
    list.shuffle(_random);
    gameItems.clear();
    gameItems.addAll(list);
  }

  void _updateTopScore(int topScore) => this.topScore = topScore;

  void _updateScore(int score) => this.score = score;

  void _updateCurrent(int current) => this.current = current;

  void onGuess(int index, bool isTrue) async {
    final isActuallyTrue = gameItems[current].fake != null;
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
    _updateCurrent(index);

    await _onUpdatePalette();

    debugPrint('Score: $score/$topScore. Card: $current/${gameItems.length}');
  }

  Future<void> onReset() async {
    _updateCurrent(0);
    _updateScore(0);
    _updateTopScore(0);
    await onStartGame();
  }

  void _setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
