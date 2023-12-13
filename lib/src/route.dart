/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:33:16
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-13 17:38:15
 * @FilePath: \flashcard-flutter\lib\src\route.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flashcard/src/auth.dart';
import 'package:flashcard/src/layout/home.dart';
import 'package:flashcard/src/screen/account.dart';
import 'package:flashcard/src/screen/my.dart';
import 'package:flashcard/src/screen/record.dart';
import 'package:flashcard/src/screen/review.dart';
import 'package:flashcard/src/widget/fade_transition_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

final appShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'app shell');
final booksNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'books shell');

final homeRoutes = {
  "/record": const Record(),
  "/review": const Review(),
  "/my": const My(),
};

GoRouter router() {
  final Auth auth = Auth();
  return GoRouter(
    observers: [TalkerRouteObserver(GetIt.instance<Talker>())],
    refreshListenable: auth,
    debugLogDiagnostics: true,
    initialLocation: '/record',
    redirect: (context, state) {
      final signedIn = Auth.of(context).signedIn;
      if (!state.uri.toString().startsWith('/account') && !signedIn) {
        return '/account/register';
      }
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: appShellNavigatorKey,
        builder: (context, state, child) =>
            HomeScaffold(state: state, child: child),
        routes: homeRoutes.entries
            .map((entry) => GoRoute(
                  path: entry.key,
                  pageBuilder: (context, state) {
                    return FadeTransitionPage<dynamic>(
                      key: state.pageKey,
                      child: Builder(builder: (context) {
                        return entry.value;
                      }),
                    );
                  },
                ))
            .toList(),
      ),
      GoRoute(
        path: '/account/:entry',
        builder: (context, state) {
          // Use a builder to get the correct BuildContext
          return Builder(
            builder: (context) {
              return Account(routerState: state);
            },
          );
        },
      ),
    ],
  );
}
