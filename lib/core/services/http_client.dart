import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client;
  final Map<String, Map<String, dynamic>> _cache = {};

  static String get _apiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String path, [Map<String, String>? params]) {
    final query = {
      'api_key': _apiKey,
      'language': 'pt-BR',
      ...?params,
    };
    return Uri.parse('${ApiConstants.baseUrl}$path').replace(queryParameters: query);
  }

  Future<Map<String, dynamic>> get(String path, [Map<String, String>? params]) async {
    final uri = _buildUri(path, params);
    final key = uri.toString();

    if (_cache.containsKey(key)) return _cache[key]!;

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    _cache[key] = decoded;
    return decoded;
  }

  void clearCache() => _cache.clear();

  void dispose() => _client.close();
}
