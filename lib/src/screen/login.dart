/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:50:08
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-08 13:49:34
 * @FilePath: /flashcard/lib/src/screen/login.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flutter/material.dart';

const phi = 1.618, width = 357.0, height = width * phi;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _fromField = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Center(
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
                          '登录',
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
                                TextFormField(
                                  controller: _fromField['email'],
                                  decoration: const InputDecoration(
                                    hintText: '邮箱',
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '请输入邮箱';
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
                                  decoration: const InputDecoration(
                                    hintText: '密码',
                                    prefixIcon: Icon(Icons.lock_outline),
                                    suffixIcon: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // added line
                                      mainAxisSize:
                                          MainAxisSize.min, // added line

                                      children: [
                                        Wrap(
                                            spacing:
                                                12, // to apply margin in the main axis of the wrap
                                            runSpacing: 12, // to apply margin in the cross axis of the wrap
                                            children: [
                                              Icon(Icons
                                                  .remove_red_eye_outlined),
                                              Icon(Icons.clear)
                                            ])
                                      ],
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {

                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .primaryColor, // Set the button color to primaryColor
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  '登录',
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
          )),
    );
  }
}
