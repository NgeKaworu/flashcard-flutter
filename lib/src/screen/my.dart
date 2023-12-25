/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:50:16
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-25 13:27:31
 * @FilePath: /flashcard/lib/src/screen/my.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flashcard/src/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class My extends StatelessWidget {
  const My({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Text("My page"),
          ElevatedButton(
              onPressed: auth.signOut,
              child: const Text(
                "登出",
              ))
        ],
      ),
    );
  }
}
