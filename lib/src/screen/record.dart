/*
 * @Date: 2023-12-04 13:04:42
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-28 13:55:24
 * @FilePath: /flashcard/lib/src/screen/record.dart
 */
// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const tabs = [
  Tab(
    text: '可复习',
  ),
  Tab(
    text: '冷却中',
  ),
  Tab(
    text: '已完成',
  ),
  Tab(
    text: '全部',
  ),
];

class Record extends StatefulWidget {
  final GoRouterState? routerState;

  const Record({
    required this.routerState,
    super.key,
  });

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final route = GoRouter.of(context);

    final routeState = widget.routerState;

    final queryParameters = routeState?.uri.queryParameters;
    
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            
            indicatorColor: Colors.white,
            onTap: (value) {
              print(value);
              route.go('/home/record?test=$value');
              setState(() => selectedIndex = value);
            },
            tabs: tabs,
          ),
        ),
        body: const Text('New'),
      ),
    );
  }
}
