/*
 * @Date: 2023-12-26 13:33:49
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-30 23:58:44
 * @FilePath: \flashcard-flutter\lib\src\model\response.dart
 */

import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Response<T> {
  T data;
  bool ok;
  int? total;
  String? errMsg;

  Response(this.data, this.ok, this.total, this.errMsg);

  factory Response.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$ResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ResponseToJson(this, toJsonT);
}
