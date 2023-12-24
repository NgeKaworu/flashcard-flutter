/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-04 13:04:42
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-24 17:16:49
 * @FilePath: \flashcard-flutter\lib\src\auth.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A mock authentication service
class Auth extends ChangeNotifier {
  Auth() {
    SharedPreferences.getInstance().then((prefs) {
      _signedIn = prefs.containsKey('token');
      notifyListeners();
    });
  }

  bool _signedIn = true;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('refresh_token');
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String token, String? refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    if (null != refreshToken) prefs.setString('refresh_token', refreshToken);
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
