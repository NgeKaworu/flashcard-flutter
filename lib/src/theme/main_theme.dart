/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-06 13:38:23
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-10 17:08:13
 * @FilePath: /flashcard/lib/src/theme/mainTheme.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flutter/material.dart';

Color tomato = const Color.fromRGBO(255, 99, 71, 1);

final mainTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: tomato),
  useMaterial3: true,
);
