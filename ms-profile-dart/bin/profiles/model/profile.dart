import 'dart:convert';

class Profile {
  String? id;
  String name;
  String email;
  int age;

  Profile({
    this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  factory Profile.fromJson(Map<String, dynamic> map) => Profile(
      id: map["_id"], name: map["name"], email: map["email"], age: map["age"]);

  Map<String, dynamic> toJson() =>
      {"_id": id, "name": name, "email": email, "age": age};

  @override
  String toString() =>
      'Profile{id: $id, name: $name, email: $email, age: $age}';
}

List<Profile> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String profileToJson(Profile data) => json.encode(data.toJson());
