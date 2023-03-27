// ignore_for_file: invalid_annotation_target

import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/country.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
class GameState with _$GameState {
  static GameState empty =
      const GameState(score: 0, topScore: 1, countries: []);

  const factory GameState({
    @JsonKey(name: 'score') required final int score,
    @JsonKey(name: 'topScore') required final int topScore,
    @JsonKey(name: 'countries') required final List<Country> countries,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

extension GameStateExt on GameState {
  double get progress => max(0, score) / topScore;
}
