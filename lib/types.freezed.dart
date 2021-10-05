// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PromptInfoTearOff {
  const _$PromptInfoTearOff();

  _PromptInfo call(String schemaname, String headname) {
    return _PromptInfo(
      schemaname,
      headname,
    );
  }
}

/// @nodoc
const $PromptInfo = _$PromptInfoTearOff();

/// @nodoc
mixin _$PromptInfo {
  String get schemaname => throw _privateConstructorUsedError;
  String get headname => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PromptInfoCopyWith<PromptInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptInfoCopyWith<$Res> {
  factory $PromptInfoCopyWith(
          PromptInfo value, $Res Function(PromptInfo) then) =
      _$PromptInfoCopyWithImpl<$Res>;
  $Res call({String schemaname, String headname});
}

/// @nodoc
class _$PromptInfoCopyWithImpl<$Res> implements $PromptInfoCopyWith<$Res> {
  _$PromptInfoCopyWithImpl(this._value, this._then);

  final PromptInfo _value;
  // ignore: unused_field
  final $Res Function(PromptInfo) _then;

  @override
  $Res call({
    Object? schemaname = freezed,
    Object? headname = freezed,
  }) {
    return _then(_value.copyWith(
      schemaname: schemaname == freezed
          ? _value.schemaname
          : schemaname // ignore: cast_nullable_to_non_nullable
              as String,
      headname: headname == freezed
          ? _value.headname
          : headname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$PromptInfoCopyWith<$Res> implements $PromptInfoCopyWith<$Res> {
  factory _$PromptInfoCopyWith(
          _PromptInfo value, $Res Function(_PromptInfo) then) =
      __$PromptInfoCopyWithImpl<$Res>;
  @override
  $Res call({String schemaname, String headname});
}

/// @nodoc
class __$PromptInfoCopyWithImpl<$Res> extends _$PromptInfoCopyWithImpl<$Res>
    implements _$PromptInfoCopyWith<$Res> {
  __$PromptInfoCopyWithImpl(
      _PromptInfo _value, $Res Function(_PromptInfo) _then)
      : super(_value, (v) => _then(v as _PromptInfo));

  @override
  _PromptInfo get _value => super._value as _PromptInfo;

  @override
  $Res call({
    Object? schemaname = freezed,
    Object? headname = freezed,
  }) {
    return _then(_PromptInfo(
      schemaname == freezed
          ? _value.schemaname
          : schemaname // ignore: cast_nullable_to_non_nullable
              as String,
      headname == freezed
          ? _value.headname
          : headname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PromptInfo implements _PromptInfo {
  _$_PromptInfo(this.schemaname, this.headname);

  @override
  final String schemaname;
  @override
  final String headname;

  @override
  String toString() {
    return 'PromptInfo(schemaname: $schemaname, headname: $headname)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PromptInfo &&
            (identical(other.schemaname, schemaname) ||
                const DeepCollectionEquality()
                    .equals(other.schemaname, schemaname)) &&
            (identical(other.headname, headname) ||
                const DeepCollectionEquality()
                    .equals(other.headname, headname)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(schemaname) ^
      const DeepCollectionEquality().hash(headname);

  @JsonKey(ignore: true)
  @override
  _$PromptInfoCopyWith<_PromptInfo> get copyWith =>
      __$PromptInfoCopyWithImpl<_PromptInfo>(this, _$identity);
}

abstract class _PromptInfo implements PromptInfo {
  factory _PromptInfo(String schemaname, String headname) = _$_PromptInfo;

  @override
  String get schemaname => throw _privateConstructorUsedError;
  @override
  String get headname => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PromptInfoCopyWith<_PromptInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
