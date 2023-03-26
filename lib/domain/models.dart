import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameItems {
  final Country original;
  final Country? fake;

  const GameItems({required this.original, this.fake});

  String get country => fake?.name ?? original.name;

  String? get capital => fake?.capital ?? original.capital;

  ImageProvider get image => original.image;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameItems &&
        other.original == original &&
        other.fake == fake;
  }

  @override
  int get hashCode => original.hashCode ^ fake.hashCode;
}

class Country {
  final String name;
  final String capital;
  final List<String> imageUrls;
  final int index;

  const Country(
    this.name,
    this.capital, {
    this.imageUrls = const [''],
    this.index = 0,
  });

  ImageProvider get image => NetworkImage('${imageUrls[index]}?w=600');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Country &&
        other.name == name &&
        other.capital == capital &&
        listEquals(other.imageUrls, imageUrls) &&
        other.index == index;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        capital.hashCode ^
        imageUrls.hashCode ^
        index.hashCode;
  }
}

class ColorPair {
  final Color main;
  final Color second;

  const ColorPair(this.main, this.second);
}
