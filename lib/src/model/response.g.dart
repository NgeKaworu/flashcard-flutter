// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response<T> _$ResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Response<T>(
      fromJsonT(json['data']),
      json['ok'] as bool,
      json['total'] as int?,
      json['errMsg'] as String?,
    );

Map<String, dynamic> _$ResponseToJson<T>(
  Response<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
      'ok': instance.ok,
      'total': instance.total,
      'errMsg': instance.errMsg,
    };
