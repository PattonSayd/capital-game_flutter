// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GameItems _$$_GameItemsFromJson(Map<String, dynamic> json) => _$_GameItems(
      original: Country.fromJson(json['original'] as Map<String, dynamic>),
      fake: json['fake'] == null
          ? null
          : Country.fromJson(json['fake'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_GameItemsToJson(_$_GameItems instance) =>
    <String, dynamic>{
      'original': instance.original,
      'fake': instance.fake,
    };
