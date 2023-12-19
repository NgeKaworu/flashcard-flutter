import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flashcard/src/route.dart';

class Extra {
  // 是否偷偷摸摸抛异常
  bool? sneakyThrows;
  // 是否通知
  Object? notify;
  // 是否重新登录
  bool? reAuth;

  Extra({this.sneakyThrows, this.notify, this.reAuth});
}

// 状态码对映的消息
const codeMessage = {
  200: '操作成功。',
  201: '新建或修改数据成功。',
  202: '一个请求已经进入后台排队（异步任务）。',
  204: '删除数据成功。',
  400: '发出的请求有错误，服务器没有进行新建或修改数据的操作。',
  401: '用户没有权限（令牌、用户名、密码错误）。',
  403: '用户得到授权，但是访问是被禁止的。',
  404: '发出的请求针对的是不存在的记录，服务器没有进行操作。',
  405: '请求方式不对',
  406: '请求的格式不可得。',
  410: '请求的资源被永久删除，且不会再得到的。',
  422: '当创建一个对象时，发生一个验证错误。',
  500: '服务器发生错误，请检查服务器。',
  502: '网关错误。',
  503: '服务不可用，服务器暂时过载或维护。',
  504: '网关超时。',
};

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
      options.headers['Authorization'] = options.headers['Authorization'] ??
          'Bearer ${prefs.getString("token")}';
      return handler.next(options);
    },
  ));

  // default extra
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。

      options.extra['sneakyThrows'] = options.extra['sneakyThrows'] ?? true;
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
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      if ([true, 'success']
          .contains(response.requestOptions.extra["notify"] ?? false)) {
        Fluttertoast.showToast(msg: response.data["message"] ?? '操作成功');
      }

      return handler.next(response);
    },
  ));

// error handler
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException error, ErrorInterceptorHandler handler) async {
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      var message = error.message;
      var response = error.response;
      var extra = error.requestOptions.extra;

      // undo
      if (response?.statusCode == 401) {
        if (extra['reAuth'] ?? false) {
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var res = await dio.get('/uc/oauth2/refresh',
                queryParameters: {"token": prefs.getString("refresh_token")},
                options: Options(
                  extra: {
                    "reAuth": false,
                    "notify": 'fail',
                  },
                ));
            prefs.setString('token', res.data["token"]);
            prefs.setString('refresh_token', res.data["refresh_token"]);

            var extra = error.requestOptions.extra;
            extra['reAuth'] = false;

            return handler.resolve(await dio.request(error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                cancelToken: error.requestOptions.cancelToken,
                onSendProgress: error.requestOptions.onSendProgress,
                onReceiveProgress: error.requestOptions.onReceiveProgress,
                options: Options(
                  method: error.requestOptions.method,
                  sendTimeout: error.requestOptions.sendTimeout,
                  receiveTimeout: error.requestOptions.receiveTimeout,
                  extra: extra,
                  headers: error.requestOptions.headers,
                  preserveHeaderCase: error.requestOptions.preserveHeaderCase,
                  responseType: error.requestOptions.responseType,
                  contentType: error.requestOptions.contentType,
                  validateStatus: error.requestOptions.validateStatus,
                  receiveDataWhenStatusError:
                      error.requestOptions.receiveDataWhenStatusError,
                  followRedirects: error.requestOptions.followRedirects,
                  maxRedirects: error.requestOptions.maxRedirects,
                  persistentConnection:
                      error.requestOptions.persistentConnection,
                  requestEncoder: error.requestOptions.requestEncoder,
                  responseDecoder: error.requestOptions.responseDecoder,
                  listFormat: error.requestOptions.listFormat,
                )));
          } catch (e) {
            handler.reject(error);
          
          }
        } else {
          Fluttertoast.showToast(msg: '请重新登录');
          router.go("/account/login");
        }
      }

      if ([true, 'fail'].contains(extra["notify"] ?? false)) {
        var netErrMsg = message?.contains('connection errored') == true
            ? '网络错误，请检查网络。'
            : null;

        var content =
            // 网络错误
            netErrMsg ??
                message ??
                // 错误码错误
                codeMessage[response?.statusCode] ??
                '未知错误';

        Fluttertoast.showToast(msg: content);
      }

      // 偷偷摸摸抛异常
      if (extra["sneakyThrows"]) {
        return handler.resolve(
            response ?? Response(requestOptions: error.requestOptions));
      }

      return handler.next(error);
    },
  ));

  GetIt.instance.registerSingleton(dio);
  GetIt.instance<Talker>().info('Repositories initialization completed');
}