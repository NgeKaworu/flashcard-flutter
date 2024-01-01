/*
 * @Date: 2023-12-26 13:33:49
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-31 03:00:52
 * @FilePath: \flashcard-flutter\lib\src\model\record.dart
 */

import 'package:json_annotation/json_annotation.dart';
part 'record.g.dart';

@JsonSerializable()
class Record {
  @JsonKey(name: '_id')
  final String id;
  final String cooldownAt;
  final String createAt;
  final int exp;
  final bool inReview;
  final int? mode;
  final String reviewAt;
  final String source;
  final String? tag;
  final String translation;
  final String uid;

  Record({
    required this.id,
    required this.cooldownAt,
    required this.createAt,
    required this.exp,
    required this.inReview,
    this.mode,
    required this.reviewAt,
    required this.source,
    this.tag,
    required this.translation,
    required this.uid,
  });

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  Map<String, dynamic> toJson() => _$RecordToJson(this);
}

// This function runs in a separate isolate
List<Record> parseRecords(List recordsJson) {
  return recordsJson.map((item) => Record.fromJson(item)).toList();
}
