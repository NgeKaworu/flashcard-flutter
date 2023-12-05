/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-04 13:38:59
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-04 23:38:32
 * @FilePath: \flashcard-flutter\lib\src\scaffold\home.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScaffold extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const HomeScaffold({
    required this.child,
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);

    var selectedIndex = switch (state.uri.path) {
      var p when p.startsWith('/books') => 0,
      var p when p.startsWith('/authors') => 1,
      var p when p.startsWith('/settings') => 2,
      _ => 0,
    };
    
    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: child,
        onDestinationSelected: (idx) {
          if (idx == 0) goRouter.go('/record');
          if (idx == 1) goRouter.go('/review');
          if (idx == 2) goRouter.go('/my');
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: '新词本',
            icon: Icons.edit_document,
          ),
          AdaptiveScaffoldDestination(
            title: '复习',
            icon: Icons.sync,
          ),
          AdaptiveScaffoldDestination(title: '我的', icon: Icons.person),
        ],
      ),
    );
  }
}
