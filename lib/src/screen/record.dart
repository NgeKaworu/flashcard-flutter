/*
 * @Date: 2023-12-04 13:04:42
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-27 13:47:02
 * @FilePath: /flashcard/lib/src/screen/record.dart
 */
// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class Record extends StatefulWidget {
  const Record({
    super.key,
  });

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            indicatorColor: Colors.white,
            onTap: (value) {
              print(value);
              setState(() => selectedIndex = value);
            },
            tabs: const [
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
            ],
          ),
        ),
        body: const Text('New'),
      ),
    );
  }
}
