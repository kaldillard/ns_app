import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Thin wrapper around [http] for calling the exercise API. Centralizes
/// URL building, JSON decoding, and error handling so repositories don't
/// each reimplement it.
class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  ApiClient({required this.baseUrl, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final data = await _get(path, queryParameters: queryParameters);
    if (data is! List) {
      throw ApiException('Expected a list response from $path');
    }
    return data;
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final data = await _get(path, queryParameters: queryParameters);
    if (data is! Map<String, dynamic>) {
      throw ApiException('Expected an object response from $path');
    }
    return data;
  }

  Future<dynamic> _get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: queryParameters);

    http.Response response;
    try {
      response = await _httpClient.get(uri);
    } catch (e) {
      throw ApiException('Network error calling $path: $e');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Request to $path failed (${response.statusCode}): ${response.body}',
      );
    }

    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw ApiException('Failed to parse response from $path: $e');
    }
  }
}
