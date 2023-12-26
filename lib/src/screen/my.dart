/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:50:16
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-26 13:58:50
 * @FilePath: /flashcard/lib/src/screen/my.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flashcard/src/auth.dart';
import 'package:flashcard/src/theme/main_theme.dart';
import 'package:flutter/material.dart';

class My extends StatefulWidget {
  const My({super.key});

  @override
  State<My> createState() => _MyState();
}

class _MyState extends State<My> {
  Future<String> _loadData() async {
    // Replace this with your actual data loading code
    await Future.delayed(Duration(seconds: 2));
    return 'Hello, world!';
  }

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
                            Column(
                              children: [
                                FutureBuilder<String>(
                                  future: _loadData(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 8.0,
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                8.0,
                                          ),
                                          child: Text(
                                              'Loaded data: ${snapshot.data}'),
                                        ),
                                      );
                                    }
                                  },
                                ),
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
