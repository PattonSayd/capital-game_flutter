import 'dart:async';

import 'package:capitals_quiz/domain/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteState {
  final PaletteGenerator? currentPalette;
  final PaletteGenerator? nextPalette;

  const PaletteState({
    this.currentPalette,
    this.nextPalette,
  });

  static const _defaultColor = Colors.grey;

  ColorPair get colors => currentPalette != null
      ? _buildColors(currentPalette)
      : const ColorPair(_defaultColor, _defaultColor);

  ColorPair _buildColors(PaletteGenerator? palette) {
    Color? mainColor = palette?.mutedColor?.color;
    Color? secondColor = palette?.vibrantColor?.color;
    final defaultColor = mainColor ?? secondColor ?? _defaultColor;
    mainColor = mainColor ?? defaultColor;
    secondColor = secondColor ?? defaultColor;
    return ColorPair(mainColor, secondColor);
  }

  PaletteState copyWith({
    PaletteGenerator? currentPalette,
    PaletteGenerator? nextPalette,
  }) =>
      PaletteState(
        currentPalette: currentPalette ?? this.currentPalette,
        nextPalette: nextPalette ?? this.nextPalette,
      );
}

class PaletteLogic extends Cubit<PaletteState> {
  PaletteLogic() : super(const PaletteState());

  ColorPair get colors => state.colors;

  Future<void> updatePalette(ImageProvider current, ImageProvider? next) async {
    final currentGen = state.currentPalette == null
        ? await PaletteGenerator.fromImageProvider(current)
        : state.nextPalette;
    final nextGen =
        next != null ? await PaletteGenerator.fromImageProvider(next) : null;

    _onUpdatePalette(currentGen, nextGen);
  }

  _onUpdatePalette(PaletteGenerator? current, PaletteGenerator? next) =>
      emit(state.copyWith(currentPalette: current, nextPalette: next));
}
