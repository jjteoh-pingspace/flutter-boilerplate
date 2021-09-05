library cache;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A simple in-memory and shared preferences cache
class CacheClient {
  /// A simple in-memory and shared preferences cache
  CacheClient() : _inMemoryCache = <String, Object>{};

  final Map<String, Object> _inMemoryCache;
  // late final SharedPreferences _sharedPreferences;

  /// write data into cache
  Future<void> write<T extends Object>(
      {required String key, required T value, bool persist = false}) async {
    final json = jsonEncode(value);
    if (!persist) {
      _inMemoryCache[key] = json;
    } else {
      final _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString(key, json);
    }
  }

  /// read data from cache
  Future<T?> read<T extends Object>({required String key}) async {
    final _sharedPreferences = await SharedPreferences.getInstance();

    final value = (_sharedPreferences.containsKey(key)
        ? _sharedPreferences.getString(key)
        : _inMemoryCache[key]) as String?;

    if (value != null) return jsonDecode(value) as T?;
  }

  /// remove entry with key
  Future<void> removeKey(String key) async {
    final _sharedPreferences = await SharedPreferences.getInstance();

    if (_sharedPreferences.containsKey(key)) {
      await _sharedPreferences.remove(key);
    }

    if (_inMemoryCache.containsKey(key)) {
      _inMemoryCache.remove(key);
    }
  }
}
