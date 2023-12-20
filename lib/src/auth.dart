/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-04 13:04:42
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-20 13:28:35
 * @FilePath: /flashcard/lib/src/auth.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// A mock authentication service
class Auth extends ChangeNotifier {
  bool _signedIn = false;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  @override
  bool operator ==(Object other) =>
      other is Auth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;

  static Auth of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthScope>()!.notifier!;
}

class AuthScope extends InheritedNotifier<Auth> {
  const AuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });
}

final auth = Auth();
