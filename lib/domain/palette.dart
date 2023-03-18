import 'package:capitals_quiz/domain/models.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteLogic extends ChangeNotifier {
  PaletteGenerator? _currentPalette;
  PaletteGenerator? _nextPalette;

  static const _defaultColor = Colors.grey;

  ColorPair get colors => _currentPalette != null
      ? _buildColors(_currentPalette)
      : const ColorPair(_defaultColor, _defaultColor);

  Future<void> updatePalette(ImageProvider current, ImageProvider? next) async {
    final crt = _currentPalette == null
        ? await PaletteGenerator.fromImageProvider(current)
        : _nextPalette;
    final nxt =
        next != null ? await PaletteGenerator.fromImageProvider(next) : null;

    _setState(() {
      _currentPalette = crt;
      _nextPalette = nxt;
    });
  }

  ColorPair _buildColors(PaletteGenerator? palette) {
    Color? mainColor = palette?.mutedColor?.color;
    Color? secondColor = palette?.vibrantColor?.color;
    final defaultColor = mainColor ?? secondColor ?? _defaultColor;
    mainColor = mainColor ?? defaultColor;
    secondColor = secondColor ?? defaultColor;
    return ColorPair(mainColor, secondColor);
  }

  void _setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
