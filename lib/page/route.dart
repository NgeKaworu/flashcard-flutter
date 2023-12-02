/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:33:16
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-01 13:52:49
 * @FilePath: /flashcard/lib/page/route.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flashcard/page/login.dart';
import 'package:flashcard/page/record.dart';
import 'package:flashcard/page/review.dart';
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
