import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Extra {
  // 是否偷偷摸摸抛异常
  bool? sneakyThrows;
  // 是否通知
  Object? notify;
  // 是否重新登录
  bool? reAuth;

  Extra({this.sneakyThrows, this.notify, this.reAuth});
}

void initDio() {
  // Or create `Dio` with a `BaseOptions` instance.
  final options = BaseOptions(
    baseUrl: 'https://api.furan.xyz/',
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
    },
  );
  final dio = Dio(options);
  dio.interceptors.add(GetIt.instance<TalkerDioLogger>());

// header inject
  dio.interceptors.add(InterceptorsWrapper(
    onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      SharedPreferences prefs = await SharedPreferences.getInstance();
      options.headers['Authorization'] = 'Bearer ${prefs.getString("token")}';
      return handler.next(options);
    },
  ));

// biz checked
  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      if (response.data['ok']) {
        return handler.next(response);
      }

      return handler.reject(DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['errMsg'],
          type: DioExceptionType.badResponse));
    },
  ));

  // success notify
  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      if ([true, 'success'].contains(response.requestOptions.extra["notify"] ?? false)) {
        Fluttertoast.showToast(msg: response.data["message"] ?? '操作成功');
      }

      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      return handler.next(response);
    },
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      return handler.next(response);
    },
    onError: (DioException error, ErrorInterceptorHandler handler) {
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      return handler.next(error);
    },
  ));

  GetIt.instance.registerSingleton(dio);
  GetIt.instance<Talker>().info('Repositories initialization completed');
}
