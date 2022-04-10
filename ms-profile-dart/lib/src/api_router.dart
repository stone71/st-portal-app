import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'profiles/profiles_router.dart';

class ApiRouter {
  final ProfilesRouter profilesRouter;

  ApiRouter({required this.profilesRouter});

  Handler get router {
    final router = Router();
    final prefix = '/api';

    router.mount(prefix, profilesRouter.router);

    return router;
  }
}
