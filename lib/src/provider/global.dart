import 'package:flutter/material.dart';

/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-11-26 20:15:10
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-07 14:13:54
 * @FilePath: /flashcard/lib/src/provider/global.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
class GlobalState extends ChangeNotifier {
  var foo = 'foo';

  void setFoo(String value) {
    foo = value;
    notifyListeners();
  }
}
