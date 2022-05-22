class UserModel {
  final String uid;
  final String? name;
  final String? email;

  UserModel({
    required this.uid,
    this.name,
    this.email,
  });
}

class DocModel {
  final String uid;
  final String? name;
  final String? type;
  final String? email;

  DocModel({
    required this.uid,
    this.name,
    this.type,
    this.email,
  });
}
