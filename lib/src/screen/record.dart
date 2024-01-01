/*
 * @Date: 2023-12-04 13:04:42
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-31 03:03:24
 * @FilePath: \flashcard-flutter\lib\src\screen\record.dart
 */
// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dio/dio.dart';
import 'package:flashcard/src/model/record.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flashcard/src/model/record.dart' as record_model;

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

  Future<List<record_model.Record>> _loadData() async {
    final response = await GetIt.instance<Dio>().get("/flashcard/record/list");
    final data = response.data['data'] as List;
    return compute(parseRecords, data);
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
      body: FutureBuilder<List<record_model.Record>>(
        future: _loadData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<record_model.Record>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text("${snapshot.data?[0].source}");
          }
        },
      ),
    );
  }
}
