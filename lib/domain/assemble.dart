import 'dart:math';

import 'package:capitals_quiz/domain/assemble.config.dart';
import 'package:capitals_quiz/domain/game.dart';
import 'package:capitals_quiz/domain/game_items_logic.dart';
import 'package:capitals_quiz/domain/palette.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../data/data.dart';

final getIt = GetIt.I;
const assemble = Assemble._();

@injectableInit
void configureDependencies() => getIt.init();

@module
abstract class Assemblemodule {
  @injectable
  Random provideRandom() => Random();

  @injectable
  Api provideApi() => const Api();

  @lazySingleton
  Assets provideAssets() => Assets();

  @lazySingleton
  PaletteLogic providePaletteLogic() => PaletteLogic();

  @lazySingleton
  GameItemsLogic provideGameItemsLogic(Random random) => GameItemsLogic(random);

  @lazySingleton
  GameLogic provideGameLogic(
    Random random,
    Api api,
    Assets assets,
    PaletteLogic paletteLogic,
    GameItemsLogic gameItemsLogic,
  ) =>
      GameLogic(random, api, assets, paletteLogic, gameItemsLogic);
}

class Assemble {
  Random get random => getIt.get<Random>();
  Api get api => getIt.get<Api>();
  Assets get assets => getIt.get<Assets>();
  PaletteLogic get palette => getIt.get<PaletteLogic>();
  GameItemsLogic get gameItemsLogic => getIt.get<GameItemsLogic>();
  GameLogic get game => getIt.get<GameLogic>();

  const Assemble._();
}
