/*
 * @Date: 2023-12-04 13:04:42
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-29 14:02:51
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

const types = [
  'enable',
  'cooling',
  'done',
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(_handleTabIndexChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  void _handleTabIndexChanged() {
    final queryParameters = Map<String, dynamic>.from(
        widget.routerState?.uri.queryParameters ?? {});

    if (_tabController.index < types.length) {
      queryParameters['type'] = types[_tabController.index];
    } else {
      queryParameters.remove('type');
    }

    GoRouter.of(context)
        .goNamed("/home/record", queryParameters: queryParameters);
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index =
        switch (widget.routerState?.uri.queryParameters['type']) {
      'enable' => 0,
      'cooling' => 1,
      'done' => 2,
      _ => 3,
    };

    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: const Text('New'),
    );
  }
}
