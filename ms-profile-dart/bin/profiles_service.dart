import 'profiles/model/profile.dart';
import 'package:mongo_dart/mongo_dart.dart';

const dbName = 'StPortalStore';
const dbAddress = 'mongo';
//const dbAddress = '127.0.0.1';
const defaultUri = 'mongodb://$dbAddress:27017/$dbName';

class ProfilesService {
  Future<Profile?> createProfile(Profile profile) async {
    var db = Db(defaultUri);
    await db.open();

    var collectionName = 'profiles';
    var collection = db.collection(collectionName);

    var result = await collection.insertOne(profile.toJson());
    closeDatabase(db);

    print(result);
    // find dataset!
    return null;
  }

  Future<Profile?> updateProfile(Profile profile) async {
    var db = Db(defaultUri);
    await db.open();

    var collectionName = 'profiles';
    var collection = db.collection(collectionName);

    var profileJson = profile.toJson();
    profileJson['_id'] = ObjectId.fromHexString(profile.id!);

    var result =
        await collection.replaceOne(where.id(profileJson['_id']), profileJson);

    closeDatabase(db);

    print(result);
    // find dataset!
    return null;
  }

  Future<List<Profile>> getProfiles() async {
    var db = Db(defaultUri);
    await db.open();

    var collectionName = 'profiles';
    var collection = db.collection(collectionName);

    List<Profile> profileList = [];
    await collection.find().forEach((element) {
      element['_id'] = element["_id"].toHexString();
      profileList.add(Profile.fromJson(element));
    });

    closeDatabase(db);

    return profileList;
  }

  Future<Profile?> getProfileById(String id) async {
    var db = Db(defaultUri);
    await db.open();

    var collectionName = 'profiles';
    var collection = db.collection(collectionName);

    //var result = await collection.findOne(where.eq('_id', id));
    var result = await collection.findOne(where.id(ObjectId.fromHexString(id)));
    closeDatabase(db);

    if (result != null) {
      result['_id'] = result["_id"].toHexString();
      return Profile.fromJson(result);
    }
    return null;
  }

  Future<Profile?> deleteProfileById(String id) async {
    var db = Db(defaultUri);
    await db.open();

    var collectionName = 'profiles';
    var collection = db.collection(collectionName);

    var result =
        await collection.deleteOne(where.id(ObjectId.fromHexString(id)));
    closeDatabase(db);

    print(result);
    return null;
  }

  Future closeDatabase(Db db) async {
    await db.close();
  }
}
