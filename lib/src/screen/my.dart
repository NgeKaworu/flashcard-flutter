/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:50:16
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-26 18:19:03
 * @FilePath: /flashcard/lib/src/screen/my.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:dio/dio.dart';
import 'package:flashcard/src/auth.dart';
import 'package:flashcard/src/model/user.dart';
import 'package:flashcard/src/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class My extends StatefulWidget {
  const My({super.key});

  @override
  State<My> createState() => _MyState();
}

class _MyState extends State<My> {
  Future<User> _loadData() async =>
      User.fromJson((await GetIt.instance<Dio>().get(
        "user-center/profile",
      ))
          .data['data']);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    const Expanded(
                      flex: 0,
                      child: Column(children: [
                        ListTile(
                            title: Text(
                          "个人信息",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Divider(
                          height: 0,
                        ),
                      ]),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                FutureBuilder<User>(
                                  future: _loadData(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<User> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: '昵称: ',
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.45),
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${snapshot.data?.name}',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Email: ',
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.45),
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${snapshot.data?.email}',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]);
                                    }
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: auth.signOut,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .primaryColor, // Set the button color to primaryColor
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  "登出",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
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
      ),
    );
  }
}
