/*
 * @Author: NgeKaworu NgeKaworu@163.com
 * @Date: 2023-12-02 20:53:18
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-13 17:42:55
 * @FilePath: /flashcard/lib/main.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flashcard/src/client/dio.dart';
import 'package:flashcard/src/client/talker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:url_strategy/url_strategy.dart';
import 'package:window_size/window_size.dart';

import 'src/app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initTalker();

    initDio();

    // Use package:url_strategy until this pull request is released:
    // https://github.com/flutter/flutter/pull/77103

    // Use to setHashUrlStrategy() to use "/#/" in the address bar (default). Use
    // setPathUrlStrategy() to use the path. You may need to configure your web
    // server to redirect all paths to index.html.
    //
    // On mobile platforms, both functions are no-ops.
    // setHashUrlStrategy();
    setPathUrlStrategy();

    _setupWindow();

    runApp(const App());
  }, (error, stackTrace) {
    GetIt.instance<Talker>()
        .handle(error, stackTrace, 'Uncaught app exception');
  });
}

const double windowWidth = 480;
const double windowHeight = 854;

void _setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Navigation and routing');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}
