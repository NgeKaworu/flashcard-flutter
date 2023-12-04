/*
 * @Author: fuRan NgeKaworu@gmail.com
 * @Date: 2023-12-01 13:33:16
 * @LastEditors: fuRan NgeKaworu@gmail.com
 * @LastEditTime: 2023-12-04 13:52:34
 * @FilePath: /flashcard/lib/src/route.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flashcard/src/auth.dart';
import 'package:flashcard/src/screen/login.dart';
import 'package:flashcard/src/screen/record.dart';
import 'package:flashcard/src/screen/review.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'app shell');
final booksNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'books shell');

GoRouter router() {
  final Auth auth = Auth();
  return GoRouter(
    refreshListenable: auth,
    debugLogDiagnostics: true,
    initialLocation: '/books/popular',
    redirect: (context, state) {
      final signedIn = Auth.of(context).signedIn;
      if (state.uri.toString() != '/sign-in' && !signedIn) {
        return '/sign-in';
      }
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: appShellNavigatorKey,
        builder: (context, state, child) {
          return BookstoreScaffold(
            selectedIndex: switch (state.uri.path) {
              var p when p.startsWith('/books') => 0,
              var p when p.startsWith('/authors') => 1,
              var p when p.startsWith('/settings') => 2,
              _ => 0,
            },
            child: child,
          );
        },
        routes: [
          ShellRoute(
            pageBuilder: (context, state, child) {
              return FadeTransitionPage<dynamic>(
                key: state.pageKey,
                // Use a builder to get the correct BuildContext
                // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                child: Builder(builder: (context) {
                  return BooksScreen(
                    onTap: (idx) {
                      GoRouter.of(context).go(switch (idx) {
                        0 => '/books/popular',
                        1 => '/books/new',
                        2 => '/books/all',
                        _ => '/books/popular',
                      });
                    },
                    selectedIndex: switch (state.uri.path) {
                      var p when p.startsWith('/books/popular') => 0,
                      var p when p.startsWith('/books/new') => 1,
                      var p when p.startsWith('/books/all') => 2,
                      _ => 0,
                    },
                    child: child,
                  );
                }),
              );
            },
            routes: [
              GoRoute(
                path: '/books/popular',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    // Use a builder to get the correct BuildContext
                    // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                    key: state.pageKey,
                    child: Builder(
                      builder: (context) {
                        return BookList(
                          books: libraryInstance.popularBooks,
                          onTap: (book) {
                            GoRouter.of(context)
                                .go('/books/popular/book/${book.id}');
                          },
                        );
                      },
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'book/:bookId',
                    parentNavigatorKey: appShellNavigatorKey,
                    builder: (context, state) {
                      return BookDetailsScreen(
                        book: libraryInstance
                            .getBook(state.pathParameters['bookId'] ?? ''),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/books/new',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    // Use a builder to get the correct BuildContext
                    // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                    child: Builder(
                      builder: (context) {
                        return BookList(
                          books: libraryInstance.newBooks,
                          onTap: (book) {
                            GoRouter.of(context)
                                .go('/books/new/book/${book.id}');
                          },
                        );
                      },
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'book/:bookId',
                    parentNavigatorKey: appShellNavigatorKey,
                    builder: (context, state) {
                      return BookDetailsScreen(
                        book: libraryInstance
                            .getBook(state.pathParameters['bookId'] ?? ''),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/books/all',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    // Use a builder to get the correct BuildContext
                    // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                    child: Builder(
                      builder: (context) {
                        return BookList(
                          books: libraryInstance.allBooks,
                          onTap: (book) {
                            GoRouter.of(context)
                                .go('/books/all/book/${book.id}');
                          },
                        );
                      },
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'book/:bookId',
                    parentNavigatorKey: appShellNavigatorKey,
                    builder: (context, state) {
                      return BookDetailsScreen(
                        book: libraryInstance
                            .getBook(state.pathParameters['bookId'] ?? ''),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/authors',
            pageBuilder: (context, state) {
              return FadeTransitionPage<dynamic>(
                key: state.pageKey,
                child: Builder(builder: (context) {
                  return AuthorsScreen(
                    onTap: (author) {
                      GoRouter.of(context).go('/authors/author/${author.id}');
                    },
                  );
                }),
              );
            },
            routes: [
              GoRoute(
                path: 'author/:authorId',
                builder: (context, state) {
                  final author = libraryInstance.allAuthors.firstWhere(
                      (author) =>
                          author.id ==
                          int.parse(state.pathParameters['authorId']!));
                  // Use a builder to get the correct BuildContext
                  // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                  return Builder(builder: (context) {
                    return AuthorDetailsScreen(
                      author: author,
                      onBookTapped: (book) {
                        GoRouter.of(context).go('/books/all/book/${book.id}');
                      },
                    );
                  });
                },
              )
            ],
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) {
              return FadeTransitionPage<dynamic>(
                key: state.pageKey,
                child: const SettingsScreen(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) {
          // Use a builder to get the correct BuildContext
          return Builder(
            builder: (context) {
              return const Login();
            },
          );
        },
      ),
    ],
  );
}
