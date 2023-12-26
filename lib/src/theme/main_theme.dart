/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-06 13:38:23
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-26 13:31:39
 * @FilePath: /flashcard/lib/src/theme/main_theme.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flutter/material.dart';

Color tomato = const Color.fromRGBO(255, 99, 71, 1);

const phi = 1.618, width = 357.0, height = width * phi;

final mainTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: tomato),
  useMaterial3: true,
);
