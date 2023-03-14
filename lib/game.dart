import 'dart:math';

import 'package:capitals_quiz/data.dart';
import 'package:capitals_quiz/models.dart';
import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

const _successGuess = 3;
const _successFake = 1;
const _fail = -1;

const _countryLimit = 30;

final _random = Random();

mixin GameMixin<T extends StatefulWidget> on State<T> {
  var topScore = 0;
  var score = 0;
  var current = 0;

  final gameItems = <GameItem>[];

  PaletteGenerator? currentPalette;
  PaletteGenerator? nextPalette;

  bool get isCompleted => current == gameItems.length;

  Future<void> onInit() async {
    await Assets.loadPictures();
    await _onSetupGame();
    await _onUpdatePalette();
    setState(() {});
  }

  Future<void> _onUpdatePalette() async {
    currentPalette = currentPalette == null
        ? await PaletteGenerator.fromImageProvider(gameItems[current].image)
        : nextPalette;
    nextPalette = (current + 1) < gameItems.length
        ? await PaletteGenerator.fromImageProvider(gameItems[current + 1].image)
        : null;
  }

  Future<void> _onSetupGame() async {
    try {
      var countries = await Api.fetchCountries();
      countries = _mergeCountryWithImages(countries);
      countries.shuffle(_random);
      countries = countries.sublist(0, _countryLimit);
      _updateItems(countries);
    } catch (e) {
      debugPrint(e.toString());
    }
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
    _updateTopScore(topScore + originals.length + _successGuess);
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

  void onGuess(int index, bool isTrue, bool isActuallyTrue) async {
    var scoreUpdate = 0;

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

    print('Score: $score/$topScore. Card: $current/${gameItems.length}');

    setState(() {});
  }

  void reset() {
    _updateCurrent(0);
    _updateScore(0);
    _updateTopScore(0);
    final countries = gameItems.map((e) => e.original).toList();
    _updateItems(countries);
    setState(() {});
  }
}
