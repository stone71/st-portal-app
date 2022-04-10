import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'profiles/model/profile.dart';
import 'profiles_service.dart';


class ProfilesRouter {
  final ProfilesService profilesService = ProfilesService();
  ProfilesRouter();

  Future<Response>  _getProfilesHandler(Request req) async {
    final id = req.params['id'];
    final profiles = await profilesService.getProfiles();

    return Response.ok(jsonEncode(profiles));
  }

  Future<Response>  _getProfilesByIdHandler(Request req) async {
    final id = req.params['id'];
    final profile = await profilesService.getProfileById(id!);

    return Response.ok(jsonEncode(profile));
  }

  Future<Response> _deleteProfilesByIdHandler(Request req) async {
    final id = req.params['id'];
    final profile = await profilesService.deleteProfileById(id!);

    return Response.ok(jsonEncode(profile));
  }

  Future<Response> _createProfilesHandler(Request req) async {
    final requestBody = await req.readAsString();
    final requestData = json.decode(requestBody);

    final profile = Profile.fromJson(requestData);

    final newProfile = await profilesService.createProfile(profile);

    return Response.ok(jsonEncode(newProfile));
  }

  Future<Response> _updateProfilesHandler(Request req) async {
    final requestBody = await req.readAsString();
    final requestData = json.decode(requestBody);

    final profile = Profile.fromJson(requestData);

    final newProfile = await profilesService.updateProfile(profile);

    return Response.ok(jsonEncode(newProfile));
  }

// Configure routes.
  Handler get router {
    final router = Router();
    router.get('/profiles', _getProfilesHandler);
    router.get('/profiles/<id>', _getProfilesByIdHandler);
    router.delete('/profiles/<id>', Pipeline().addHandler(_deleteProfilesByIdHandler));
    router.post('/profiles', Pipeline().addHandler(_createProfilesHandler));
    router.put('/profiles',
        Pipeline()
            //.addMiddleware(authorize(usersService, jwtService))
            .addHandler(_updateProfilesHandler));

    return router;
  }
}
