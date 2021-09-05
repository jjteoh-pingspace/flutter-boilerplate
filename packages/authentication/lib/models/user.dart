import 'package:equatable/equatable.dart';

/// user model
class User extends Equatable {
  /// user model
  const User({
    required this.id,
    required this.email,
    this.username,
  });

  /// instantiate user from json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String?,
    );
  }

  /// instantiate empty user object
  static const empty = User(id: 0, email: '');

  /// user id
  final int id;

  /// username
  final String? username;

  /// email
  final String email;


  /// check current user is empty
  bool get isEmpty => this == User.empty;

  /// check current user is not empty
  bool get isNotEmpty => this != User.empty;


  /// parse object to json
  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'username': username,
      'email': email,
    };

    return json;
  }

  @override
  List<Object> get props => [id, email];
}
