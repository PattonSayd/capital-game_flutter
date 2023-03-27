// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_items_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GameItemsState _$GameItemsStateFromJson(Map<String, dynamic> json) {
  return _GameItemsState.fromJson(json);
}

/// @nodoc
mixin _$GameItemsState {
  @JsonKey(name: 'currentIndex')
  int get currentIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'gameItems')
  List<GameItems> get gameItems => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameItemsStateCopyWith<GameItemsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameItemsStateCopyWith<$Res> {
  factory $GameItemsStateCopyWith(
          GameItemsState value, $Res Function(GameItemsState) then) =
      _$GameItemsStateCopyWithImpl<$Res, GameItemsState>;
  @useResult
  $Res call(
      {@JsonKey(name: 'currentIndex') int currentIndex,
      @JsonKey(name: 'gameItems') List<GameItems> gameItems});
}

/// @nodoc
class _$GameItemsStateCopyWithImpl<$Res, $Val extends GameItemsState>
    implements $GameItemsStateCopyWith<$Res> {
  _$GameItemsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
    Object? gameItems = null,
  }) {
    return _then(_value.copyWith(
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      gameItems: null == gameItems
          ? _value.gameItems
          : gameItems // ignore: cast_nullable_to_non_nullable
              as List<GameItems>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GameItemsStateCopyWith<$Res>
    implements $GameItemsStateCopyWith<$Res> {
  factory _$$_GameItemsStateCopyWith(
          _$_GameItemsState value, $Res Function(_$_GameItemsState) then) =
      __$$_GameItemsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'currentIndex') int currentIndex,
      @JsonKey(name: 'gameItems') List<GameItems> gameItems});
}

/// @nodoc
class __$$_GameItemsStateCopyWithImpl<$Res>
    extends _$GameItemsStateCopyWithImpl<$Res, _$_GameItemsState>
    implements _$$_GameItemsStateCopyWith<$Res> {
  __$$_GameItemsStateCopyWithImpl(
      _$_GameItemsState _value, $Res Function(_$_GameItemsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
    Object? gameItems = null,
  }) {
    return _then(_$_GameItemsState(
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      gameItems: null == gameItems
          ? _value._gameItems
          : gameItems // ignore: cast_nullable_to_non_nullable
              as List<GameItems>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GameItemsState implements _GameItemsState {
  const _$_GameItemsState(
      {@JsonKey(name: 'currentIndex') required this.currentIndex,
      @JsonKey(name: 'gameItems') required final List<GameItems> gameItems})
      : _gameItems = gameItems;

  factory _$_GameItemsState.fromJson(Map<String, dynamic> json) =>
      _$$_GameItemsStateFromJson(json);

  @override
  @JsonKey(name: 'currentIndex')
  final int currentIndex;
  final List<GameItems> _gameItems;
  @override
  @JsonKey(name: 'gameItems')
  List<GameItems> get gameItems {
    if (_gameItems is EqualUnmodifiableListView) return _gameItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gameItems);
  }

  @override
  String toString() {
    return 'GameItemsState(currentIndex: $currentIndex, gameItems: $gameItems)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameItemsState &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            const DeepCollectionEquality()
                .equals(other._gameItems, _gameItems));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentIndex,
      const DeepCollectionEquality().hash(_gameItems));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GameItemsStateCopyWith<_$_GameItemsState> get copyWith =>
      __$$_GameItemsStateCopyWithImpl<_$_GameItemsState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GameItemsStateToJson(
      this,
    );
  }
}

abstract class _GameItemsState implements GameItemsState {
  const factory _GameItemsState(
      {@JsonKey(name: 'currentIndex')
          required final int currentIndex,
      @JsonKey(name: 'gameItems')
          required final List<GameItems> gameItems}) = _$_GameItemsState;

  factory _GameItemsState.fromJson(Map<String, dynamic> json) =
      _$_GameItemsState.fromJson;

  @override
  @JsonKey(name: 'currentIndex')
  int get currentIndex;
  @override
  @JsonKey(name: 'gameItems')
  List<GameItems> get gameItems;
  @override
  @JsonKey(ignore: true)
  _$$_GameItemsStateCopyWith<_$_GameItemsState> get copyWith =>
      throw _privateConstructorUsedError;
}
