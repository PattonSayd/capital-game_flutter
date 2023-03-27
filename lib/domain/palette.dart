import 'dart:async';

import 'package:capitals_quiz/domain/models.dart';
import 'package:flutter/material.dart';
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

class PaletteLogic {
  var _state = const PaletteState();

  final _controller = StreamController<PaletteState>.broadcast();

  Stream<ColorPair> get stream => _controller.stream.map((state) {
        return state.colors;
      });

  ColorPair get colors => _state.colors;

  Future<void> dispose() => _controller.close();

  Future<void> updatePalette(ImageProvider current, ImageProvider? next) async {
    final crt = _state.currentPalette == null
        ? await PaletteGenerator.fromImageProvider(current)
        : _state.nextPalette;
    final nxt =
        next != null ? await PaletteGenerator.fromImageProvider(next) : null;

    _onUpdatePalette(crt, nxt);
  }

  _onUpdatePalette(PaletteGenerator? current, PaletteGenerator? next) =>
      _setState(_state.copyWith(currentPalette: current, nextPalette: next));

  void _setState(PaletteState state) {
    _state = state;
    _controller.add(_state);
  }
}
