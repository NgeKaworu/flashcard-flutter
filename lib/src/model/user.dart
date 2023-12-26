/*
 * @Date: 2023-12-26 13:33:49
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-26 13:42:55
 * @FilePath: /flashcard/lib/src/model/User.dart
 */

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String name;
  String email;

  User(this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
