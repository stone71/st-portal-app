import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:ms_profile_dart/src/api_router.dart';
import 'package:ms_profile_dart/src/profiles/profiles_router.dart';
import 'package:ms_profile_dart/src/profiles/profiles_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<HttpServer> createServer() async {
  final dbHost = Platform.environment['DB_HOST'];
  final envDbPort = Platform.environment['DB_PORT'];
  final dbName = Platform.environment['DB_NAME'];

  if (dbHost == null) {
    throw ArgumentError('Environment variable DB_HOST must be an integer');
  }

  if (envDbPort == null) {
    throw StateError('Environment variable DB_PORT is required');
  }

  if (dbName == null) {
    throw StateError('Environment variable DB_NAME is required');
  }

  final dbPort = int.tryParse(envDbPort);

  if (dbPort == null) {
    throw ArgumentError('Environment variable DB_PORT must be an integer');
  }

  print(dbHost);
  var defaultUri = 'mongodb://$dbHost:$dbPort/$dbName';
  final db = Db(defaultUri);

  final profilesService = ProfilesService(db: db);
  final profilesRouter = ProfilesRouter(profilesService: profilesService);

  final apiRouter = ApiRouter(profilesRouter: profilesRouter).router;

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: '*',
    'Content-Type': 'application/json;charset=utf-8'
  };

  // Configure a pipeline that logs requests.
  // Just add corsHeaders() middleware.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addHandler(apiRouter);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // For running in containers, we respect the PORT environment variable.
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
  return server;
}
