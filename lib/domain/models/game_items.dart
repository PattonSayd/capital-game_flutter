// ignore_for_file: invalid_annotation_target

import 'package:capitals_quiz/domain/models/country.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_items.freezed.dart';
part 'game_items.g.dart';

@freezed
class GameItems with _$GameItems {
  factory GameItems({
    @JsonKey(name: 'original') required final Country original,
    @JsonKey(name: 'fake') final Country? fake,
  }) = _GameItems;
  factory GameItems.fromJson(Map<String, dynamic> json) =>
      _$GameItemsFromJson(json);
}

extension GameItemsExp on GameItems {
  String get country => fake?.name ?? original.name;

  String? get capital => fake?.capital ?? original.capital;

  ImageProvider get image => original.image;
}
