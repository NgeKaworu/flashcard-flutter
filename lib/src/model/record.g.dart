// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      id: json['_id'] as String,
      cooldownAt: json['cooldownAt'] as String,
      createAt: json['createAt'] as String,
      exp: json['exp'] as int,
      inReview: json['inReview'] as bool,
      mode: json['mode'] as int?,
      reviewAt: json['reviewAt'] as String,
      source: json['source'] as String,
      tag: json['tag'] as String?,
      translation: json['translation'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      '_id': instance.id,
      'cooldownAt': instance.cooldownAt,
      'createAt': instance.createAt,
      'exp': instance.exp,
      'inReview': instance.inReview,
      'mode': instance.mode,
      'reviewAt': instance.reviewAt,
      'source': instance.source,
      'tag': instance.tag,
      'translation': instance.translation,
      'uid': instance.uid,
    };
