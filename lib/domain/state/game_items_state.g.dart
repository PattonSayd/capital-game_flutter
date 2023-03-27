// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_items_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GameItemsState _$$_GameItemsStateFromJson(Map<String, dynamic> json) =>
    _$_GameItemsState(
      currentIndex: json['currentIndex'] as int,
      gameItems: (json['gameItems'] as List<dynamic>)
          .map((e) => GameItems.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_GameItemsStateToJson(_$_GameItemsState instance) =>
    <String, dynamic>{
      'currentIndex': instance.currentIndex,
      'gameItems': instance.gameItems,
    };
