import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';
import 'package:event_authentication/event_authenticator_db.dart';
import 'package:event_bloc/event_bloc.dart';
import 'package:event_db/event_db.dart';
import 'package:event_file/event_file.dart';
import 'package:event_frog/event_frog.dart';
import 'package:event_frog_logger/event_frog_logger.dart';
import 'package:vhcsite_api/vhcsite_api.dart';

Handler middleware(Handler handler) {
  return _middlewareStack.use(handler);
}

final _middlewareStack = EventFrogMiddlewareStack([
  ..._providers,
  ..._requestLoggers,
  (handler) => (context) => cors(
        allowOrigin: !context.isDevelopmentMode
            ? 'https://vhcblade.com, https://*.vhcblade.com'
            : CorsDefaults.allowOrigin,
        additional: {
          'Access-Control-Expose-Headers': 'Authorization,Content-Type'
        },
      )(handler)(context),
  EventMiddleware.safeResponse,
]);

final _requestLoggers = <Middleware>[
  const AccessLogger().requestLogger,
  requestLogger(),
];

final _providers = <Middleware>[
  provider<EventEnvironment>(
    (context) => const EventEnvironment(),
  ),
  provider<DatabaseRepository>((context) => _hiveRepository),
  provider<FileRepository>(
    (context) => LocalFileRepository(Directory('../vhcsite-files')),
  ),
  provider<FileTypeRepository>((context) => FileTypeRepository()),
  provider<AuthenticationSecretsRepository>((context) => _secretRepository),
  provider<JWTSigner>(
    (context) => JWTSigner(
      () => context.read<AuthenticationSecretsRepository>().jwtSecret,
      issuer: 'vhcblade.com',
    ),
  ),
  provider<ResponseErrorBuilder>(
    // ignore: avoid_print
    (context) => ResponseErrorBuilder(
      logger: context.isDevelopmentMode ? print : null,
      logAllErrors: true,
    ),
  ),
  provider<AuthenticatedResponseBuilder>(
    (context) => AuthenticatedResponseBuilder(),
  ),
  ...ServiceManager.middlewares,
];

final _hiveRepository = HiveRepository(typeAdapters: modelTypeAdapters)
  ..initialize(BlocEventChannel());

final _secretRepository =
    FileSecretsRepository(secretsFile: '../vhcsite_api_hive/secrets.txt')
      ..initialize(BlocEventChannel());
