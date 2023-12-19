/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-04 13:04:42
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-19 17:59:48
 * @FilePath: /flashcard/lib/src/app.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flashcard/src/provider/global.dart';
import 'package:flashcard/src/auth.dart';
import 'package:flashcard/src/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth auth = Auth();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GlobalState(),
        )
      ],
      child: MaterialApp.router(
        theme: mainTheme,
        builder: (context, child) {
          if (child == null) {
            throw ('No child in .router constructor builder');
          }
          return AuthScope(
            notifier: auth,
            child: child,
          );
        },
        routerConfig: router,
      ),
    );
  }
}
