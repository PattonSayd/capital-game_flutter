import 'dart:math';

import 'package:capitals_quiz/domain/game.dart';
import 'package:capitals_quiz/domain/game_items_logic.dart';
import 'package:capitals_quiz/domain/palette.dart';

import '../data/data.dart';

class Assemble {
  static final random = Random();
  static const api = Api();
  static final assets = Assets();
  static final palette = PaletteLogic();
  static late final gameItemsLogic = GameItemsLogic(random);
  static late final game =
      GameLogic(random, api, assets, palette, gameItemsLogic);

  const Assemble._();
}
