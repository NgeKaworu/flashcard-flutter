/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:50:08
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-11 13:59:15
 * @FilePath: \flashcard-flutter\lib\src\screen\Account.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const phi = 1.618, width = 357.0, height = width * phi;

const entryMap = {
  'register': '注册',
  'login': '登录',
  'forget-pwd': '重置密码',
};

class Account extends StatefulWidget {
  final GoRouterState routerState;

  const Account({
    required this.routerState,
    super.key,
  });

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _fromField = Map.fromIterable([
    'name',
    'email',
    'captcha',
    'password',
    'confirmPwd',
  ], value: (_) => TextEditingController());

  var showPwd = false;
  var showConfirmPwd = false;

  Timer? _timer;
  int _countdown = 60;

  void fetchCaptcha() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (_countdown == 0) {
          timer.cancel();
          setState(() {
            _countdown = 60;
          });
        } else {
          setState(() {
            _countdown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var entry = widget.routerState.pathParameters['entry'] ?? "login";
    var title = entryMap[entry]!;
    var router = GoRouter.of(context);

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
                  ),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 0,
                            child: Column(children: [
                              ListTile(
                                  title: Text(
                                title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                              const Divider(
                                height: 0,
                              ),
                            ]),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      if (entry == "register")
                                        TextFormField(
                                          controller: _fromField['name'],
                                          decoration: const InputDecoration(
                                            hintText: '用户名',
                                            prefixIcon:
                                                Icon(Icons.person_outline),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '请输入用户名';
                                            }
                                            return null;
                                          },
                                        ),
                                      TextFormField(
                                        controller: _fromField['email'],
                                        decoration: const InputDecoration(
                                          hintText: '邮箱',
                                          prefixIcon:
                                              Icon(Icons.email_outlined),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '请输入邮箱';
                                          }
                                          return null;
                                        },
                                      ),
                                      if (entry != "login")
                                        TextFormField(
                                          controller: _fromField['captcha'],
                                          decoration: InputDecoration(
                                              hintText: '验证码',
                                              suffixIconConstraints:
                                                  const BoxConstraints(
                                                      maxHeight:
                                                          double.infinity),
                                              prefixIcon: const Icon(
                                                  Icons.comment_outlined),
                                              suffixIcon: TextButton(
                                                  onPressed: _countdown != 60
                                                      ? null
                                                      : () {
                                                          fetchCaptcha();
                                                        },
                                                  style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all<EdgeInsets>(
                                                                const EdgeInsets
                                                                    .all(0)),
                                                  ),
                                                  child: Text(_countdown == 60
                                                      ? '获取验证码'
                                                      : "$_countdown秒"))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '请输入验证码';
                                            }
                                            return null;
                                          },
                                        ),
                                      TextFormField(
                                        controller: _fromField['pwd'],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '请输入密码';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: '密码',
                                            prefixIcon:
                                                const Icon(Icons.lock_outline),
                                            suffixIcon: IconButton(
                                              icon: showPwd
                                                  ? const Icon(Icons.visibility)
                                                  : const Icon(
                                                      Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  showPwd = !showPwd;
                                                });
                                              },
                                            )),
                                        obscureText: !showPwd,
                                      ),
                                      if (entry != "login")
                                        TextFormField(
                                          controller: _fromField['confirmPwd'],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '请输入确认密码';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: '确认密码',
                                              prefixIcon: const Icon(
                                                  Icons.lock_outline),
                                              suffixIcon: IconButton(
                                                icon: showConfirmPwd
                                                    ? const Icon(
                                                        Icons.visibility)
                                                    : const Icon(
                                                        Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    showConfirmPwd =
                                                        !showConfirmPwd;
                                                  });
                                                },
                                              )),
                                          obscureText: !showConfirmPwd,
                                        ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Validate returns true if the form is valid, or false otherwise.
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // If the form is valid, display a snackbar. In the real world,
                                              // you'd often call a server or save the information in a database.
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Processing Data')),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .primaryColor, // Set the button color to primaryColor
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            title,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (entry != "login")
                                            TextButton(
                                              onPressed: () {
                                                router.go('/account/login');
                                              },
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                        const EdgeInsets.all(
                                                            0)),
                                              ),
                                              child: const Text('已有账号?现在登录!'),
                                            ),
                                          if (entry != "register")
                                            TextButton(
                                                onPressed: () {
                                                  router
                                                      .go('/account/register');
                                                },
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty
                                                      .all<EdgeInsets>(
                                                          const EdgeInsets.all(
                                                              0)),
                                                ),
                                                child:
                                                    const Text('没有账号？现在注册！')),
                                          if (entry != "forget-pwd")
                                            TextButton(
                                                onPressed: () {
                                                  router.go(
                                                      '/account/forget-pwd');
                                                },
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty
                                                      .all<EdgeInsets>(
                                                          const EdgeInsets.all(
                                                              0)),
                                                ),
                                                child: const Text('忘记密码?'))
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
