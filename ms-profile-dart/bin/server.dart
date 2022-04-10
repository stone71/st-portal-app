import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'api_router.dart';
import 'profiles_router.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final profilesRouter = ProfilesRouter();
  final apiRouter =
      ApiRouter(profilesRouter: profilesRouter).router;
  // Configure a pipeline that logs requests.
  final _handler =
      Pipeline().addMiddleware(logRequests()).addHandler(apiRouter);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
