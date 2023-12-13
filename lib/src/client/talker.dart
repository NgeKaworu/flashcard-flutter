import 'package:get_it/get_it.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

void initTalker() {
  final talker = TalkerFlutter.init(
      logger: TalkerLogger(
    settings: TalkerLoggerSettings(colors: {
      LogLevel.verbose: AnsiPen()..magenta(),
    }),
  ));
  GetIt.instance.registerSingleton<Talker>(talker);
  talker.verbose('Talker initialization completed');

  /// This logic is just for example here
  if (!GetIt.instance.isRegistered<Talker>()) {
    GetIt.instance.registerSingleton<Talker>(talker);
  } else {
    talker.warning('Trying to re-register an object in GetIt');
  }
  final talkerDioLogger = TalkerDioLogger(
    talker: GetIt.instance<Talker>(),
    settings: const TalkerDioLoggerSettings(
      printRequestHeaders: true,
      printResponseHeaders: true,
      printRequestData: true,
      printResponseData: true,
    ),
  );
  GetIt.instance.registerSingleton(talkerDioLogger);
}
