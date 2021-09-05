library http_client;

import 'package:http/http.dart';

/// http client
class HttpAPI {
  /// http client
  HttpAPI({Client? client}) : _client = client ?? Client();

  final Client _client;

  /// create to http GET request
  Future<Response> get(String uri, {Map<String, String>? headers}) async {
    return _client.get(Uri.parse(uri), headers: headers);
  }

  /// create to http GET request
  Future<Response> post(String uri,
      {Map<String, String>? headers, Object? body}) async {
    headers = headers ?? {};

    if (!headers.containsKey('Content-Type')) {
      headers['Content-Type'] = 'application/json';
    }
    return _client.post(Uri.parse(uri), body: body, headers: headers);
  }

  /// create to http PUT request
  Future<Response> put(String uri,
      {Map<String, String>? headers, Object? body}) async {
    return _client.put(Uri.parse(uri), body: body, headers: headers);
  }
}
