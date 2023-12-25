/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:50:08
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-25 13:50:54
 * @FilePath: /flashcard/lib/src/screen/account.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flashcard/src/auth.dart';
import 'package:flashcard/src/widget/loding_elevated_button.dart';
import 'package:flashcard/src/widget/loding_text_bottom.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

const phi = 1.618, width = 357.0, height = width * phi;

const entryMap = {
  'register': '注册',
  'login': '登录',
  'forget-pwd': '重置密码',
};

const format = "yyyy-MM-dd HH:mm:ss";
var dateFormat = DateFormat(format);

const captchaCount = 60;

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
  final _emailFieldKey = GlobalKey<FormFieldState>();

  final fields = [
    'name',
    'email',
    'captcha',
    'pwd',
    'confirmPwd',
  ];

  late Map<String, TextEditingController> _fromField;

  var showPwd = false;
  var showConfirmPwd = false;

  Timer? _timer;
  int _countdown = captchaCount;

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_countdown == 0) {
          timer.cancel();
          setState(() {
            _countdown = captchaCount;
          });
        } else {
          setState(() {
            _countdown--;
          });
        }
      },
    );
  }

  void fetchCaptcha() async {
    if (!_emailFieldKey.currentState!.validate()) {
      return;
    }
    try {
      await GetIt.instance<Dio>().get(
        "user-center/user/validate",
        queryParameters: {"email": _fromField["email"]!.text},
        options: Options(extra: {"notify": "fail", "sneakyThrows": false}),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'next_fetch_captcha_at',
          dateFormat.format(
              DateTime.now().add(const Duration(seconds: captchaCount))));

      startTimer();
    } catch (e) {
      GetIt.instance<Talker>().error(e);
    }
  }

  void onSubmit() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      final map = _fromField.map((key, value) => MapEntry(key, value.text));
      final entry = widget.routerState.pathParameters['entry'] ?? "login";
      final router = GoRouter.of(context);

      try {
        if (entry == "register") {
          await GetIt.instance<Dio>().get(
            "user-center/captcha/check",
            queryParameters: {
              "email": map["email"],
              "captcha": map["captcha"],
            },
            options: Options(extra: {"notify": "fail", "sneakyThrows": false}),
          );
        }

        final res = await GetIt.instance<Dio>().post("user-center/$entry",
            data: map, options: Options(extra: {"notify": true}));

        await auth.signIn(res.data["data"], res.data["refresh_token"]);

        router.go('/home/my');
      } catch (e) {
        GetIt.instance<Talker>().error(e);
      }
    }
  }

  @override
  initState() {
    super.initState();
    _fromField =
        Map.fromIterable(fields, value: (_) => TextEditingController());

    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var nextFetchCaptchaAtStr = prefs.getString('next_fetch_captcha_at');
      if (nextFetchCaptchaAtStr == null) {
        return;
      }

      var nextFetchCaptchaAt = dateFormat.parse(nextFetchCaptchaAtStr);

      var difference = nextFetchCaptchaAt.difference(DateTime.now());

      if (difference.inSeconds > 0) {
        setState(() {
          _countdown = difference.inSeconds;
          startTimer();
        });
      }
    })();
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
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        key: _emailFieldKey,
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

                                          if (!RegExp(
                                                  r"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$")
                                              .hasMatch(value)) {
                                            return '请输入正确的邮箱';
                                          }

                                          return null;
                                        },
                                      ),
                                      if (entry != "login")
                                        TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _fromField['captcha'],
                                          decoration: InputDecoration(
                                              hintText: '验证码',
                                              suffixIconConstraints:
                                                  const BoxConstraints(
                                                      maxHeight:
                                                          double.infinity),
                                              prefixIcon: const Icon(
                                                  Icons.comment_outlined),
                                              suffixIcon: LoadingTextButton(
                                                  onPressed:
                                                      _countdown != captchaCount
                                                          ? null
                                                          : fetchCaptcha,
                                                  style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all<EdgeInsets>(
                                                                const EdgeInsets
                                                                    .all(0)),
                                                  ),
                                                  child: Text(
                                                      _countdown == captchaCount
                                                          ? '获取验证码'
                                                          : "$_countdown秒"))),
                                          validator: (value) {
                                            if (_fromField['email']?.text ==
                                                    null ||
                                                _fromField['email']!
                                                    .text
                                                    .isEmpty) {
                                              return "请先检验邮箱";
                                            }

                                            if (value == null ||
                                                value.isEmpty) {
                                              return '请输入验证码';
                                            }

                                            if (!RegExp(r'^[0-9]{4}$')
                                                .hasMatch(value)) {
                                              return "请输入4位数验证码";
                                            }

                                            return null;
                                          },
                                        ),
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _fromField['pwd'],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '请输入密码';
                                          }

                                          if (!RegExp(
                                                  r'^(?![0-9]+$)(?![A-Z]+$)(?![a-z]+$)[0-9A-Za-z]{8,}$')
                                              .hasMatch(value)) {
                                            return "密码长度8位需包含字母大小写和数字中两种和以上";
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
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _fromField['confirmPwd'],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '请输入确认密码';
                                            }

                                            if (value !=
                                                _fromField['pwd']?.text) {
                                              return "两次密码不一致";
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
                                        child: LoadingElevatedButton(
                                          onPressed: onSubmit,
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
