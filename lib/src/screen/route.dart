/*
 * @Author: NgeKaworu NgeKaworu@163.com
 * @Date: 2023-12-02 17:46:24
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-03 19:10:45
 * @FilePath: \flashcard-flutter\lib\src\screen\route.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:33:16
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-02 21:46:57
 * @FilePath: \flashcard-flutter\lib\src\screen\route.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flashcard/src/screen/login.dart';
import 'package:flashcard/src/screen/record.dart';
import 'package:flashcard/src/screen/review.dart';
import 'package:go_router/go_router.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const Review(),
        routes: [
          GoRoute(
            path: 'cart',
            builder: (context, state) => const Record(),
          ),
        ],
      ),
    ],
  );
}
