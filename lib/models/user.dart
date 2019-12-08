import 'package:meta/meta.dart';

class User {
  int id;
  String username;
  String country;
  String email;

  User({@required this.id, this.username, this.country, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      country: json['country'] ?? '',
      email: json['email'] ?? '',
    );
  }

  @override
  String toString() {
    return '$id - $username';
  }
}
