// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/game_items.dart';

part 'game_items_state.freezed.dart';
part 'game_items_state.g.dart';

@freezed
abstract class GameItemsState with _$GameItemsState {
  static const empty = GameItemsState(currentIndex: 0, gameItems: []);

  const factory GameItemsState({
    @JsonKey(name: 'currentIndex') required final int currentIndex,
    @JsonKey(name: 'gameItems') required final List<GameItems> gameItems,
  }) = _GameItemsState;
  factory GameItemsState.fromJson(Map<String, dynamic> json) =>
      _$GameItemsStateFromJson(json);
}

extension GameItemsStateExt on GameItemsState {
  GameItems get current => gameItems[currentIndex];

  GameItems? get next => ((currentIndex + 1) < gameItems.length)
      ? gameItems[currentIndex + 1]
      : null;

  bool get isCompleted => currentIndex == gameItems.length;

  bool get isCurrentTrue => current.fake == null;

  int get originalLength =>
      gameItems.where((element) => element.fake == null).length;

  int get fakeLength => gameItems.length - originalLength;

  double get progress => currentIndex / gameItems.length;
}
