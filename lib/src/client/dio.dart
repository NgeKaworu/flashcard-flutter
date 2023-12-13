import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

void initDio() {
  final dio = Dio();
  dio.interceptors.add(GetIt.instance<TalkerDioLogger>());

  GetIt.instance<Talker>().info('Repositories initialization completed');
}
