// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:math' as _i5;

import 'package:capitals_quiz/data/data.dart' as _i3;
import 'package:capitals_quiz/domain/assemble.dart' as _i8;
import 'package:capitals_quiz/domain/game.dart' as _i7;
import 'package:capitals_quiz/domain/game_items_logic.dart' as _i6;
import 'package:capitals_quiz/domain/palette.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart'
    as _i2; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final assemblemodule = _$Assemblemodule();
    gh.factory<_i3.Api>(() => assemblemodule.provideApi());
    gh.lazySingleton<_i3.Assets>(() => assemblemodule.provideAssets());
    gh.lazySingleton<_i4.PaletteLogic>(
        () => assemblemodule.providePaletteLogic());
    gh.factory<_i5.Random>(() => assemblemodule.provideRandom());
    gh.lazySingleton<_i6.GameItemsLogic>(
        () => assemblemodule.provideGameItemsLogic(gh<_i5.Random>()));
    gh.lazySingleton<_i7.GameLogic>(() => assemblemodule.provideGameLogic(
          gh<_i5.Random>(),
          gh<_i3.Api>(),
          gh<_i3.Assets>(),
          gh<_i4.PaletteLogic>(),
          gh<_i6.GameItemsLogic>(),
        ));
    return this;
  }
}

class _$Assemblemodule extends _i8.Assemblemodule {}
