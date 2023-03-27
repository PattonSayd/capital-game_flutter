import 'dart:math';

import 'package:capitals_quiz/domain/game.dart';
import 'package:capitals_quiz/domain/game_items_logic.dart';
import 'package:capitals_quiz/domain/palette.dart';
import 'package:get_it/get_it.dart';

import '../data/data.dart';

final getIt = GetIt.I;
const assemble = Assemble._();

void setup() {
  getIt.registerFactory(() => Random());
  getIt.registerFactory(() => const Api());
  getIt.registerLazySingleton(() => Assets());
  getIt.registerLazySingleton(() => PaletteLogic());
  getIt.registerLazySingleton(() => GameItemsLogic(getIt.get<Random>()));
  getIt.registerLazySingleton(() => GameLogic(
        getIt.get<Random>(),
        getIt.get<Api>(),
        getIt.get<Assets>(),
        getIt.get<PaletteLogic>(),
        getIt.get<GameItemsLogic>(),
      ));
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
