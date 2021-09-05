import 'dart:async';
import 'dart:convert';

import 'package:jwt_decode/jwt_decode.dart';
import 'package:my_authentication/constants.dart';
import 'package:my_authentication/exceptions/exceptions.dart';
import 'package:my_authentication/models/user.dart';
import 'package:my_http_client/client.dart';
import 'package:my_cache/cache.dart';

/// authentication repository
class AuthenticationRepository {
  /// authentication repository
  AuthenticationRepository({
    CacheClient? cacheClient,
    HttpAPI? httpClient,
  })  : _cacheClient = cacheClient ?? CacheClient(),
        _httpClient = httpClient ?? HttpAPI(),
        _user = User.empty;

  final _userStream = StreamController<User>();
  final HttpAPI _httpClient;
  final CacheClient _cacheClient;
  User _user;

  /// key use to retrieve value from cache
  static const userCacheKey = '__user_cache_key__';

  /// Get logged-in user from cache
  User get currentUser {
    return _user;
  }

  /// stream of user which will emit when user authenticated or logged out
  Stream<User> get user async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield User.empty;
    yield* _userStream.stream;
  }

  /// sign up with email and password
  Future<void> signUpWithEmailPassword({
    required String email,
    required String plainPassword,
    String? username,
  }) async {
    try {
      final requestBody = <dynamic, dynamic>{
        'email': email,
        'password': plainPassword,
        'username': username,
      };

      final response = await _httpClient.post(
        signupURL,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode >= 300) {
        throw Exception(response.reasonPhrase);
      }
    } on Exception {
      throw SignUpFailure();
    }
  }

  /// sign in with email and password
  Future<void> signInWithEmailPassword(
      {required String email, required String plainPassword}) async {
    try {
      final response = await _httpClient.post(
        authURL,
        body: jsonEncode({'username': email, 'password': plainPassword}),
      );

      if (response.statusCode >= 300) {
        throw SignInWithEmailPasswordFailure();
      }

      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      final token = Jwt.parseJwt(jsonBody['token'] as String);
      // ignore: avoid_dynamic_calls
      final userID = int.parse(token['data']['user']['id'] as String);

      jsonBody['id'] = userID;

      _user = User.fromJson(jsonBody);
      _userStream.add(_user);
      await _cacheClient.write(key: userCacheKey, value: _user);
    } on Exception {
      throw SignInWithEmailPasswordFailure();
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      _user = User.empty;
      _userStream.add(_user);
      await _cacheClient.removeKey(userCacheKey);
    } on Exception {
      throw SignOutFailure();
    }
  }
}
