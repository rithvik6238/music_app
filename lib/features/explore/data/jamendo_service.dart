import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/jamendo_track.dart';

final jamendoServiceProvider = Provider((ref) => JamendoService());

class JamendoService {
  final String _baseUrl = 'https://api.jamendo.com/v3.0';

  String get _clientId {
    return dotenv.env['JAMENDO_CLIENT_ID'] ?? '';
  }

  Future<List<JamendoTrack>> getTracks({int limit = 20, int offset = 0, String order = 'popularity_total'}) async {
    final url = Uri.parse(
        '$_baseUrl/tracks/?client_id=$_clientId&format=json&limit=$limit&offset=$offset&order=$order&include=musicinfo&audioformat=mp32');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => JamendoTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tracks from Jamendo API');
    }
  }

  Future<List<JamendoTrack>> searchTracks(String query, {int limit = 20}) async {
    final url = Uri.parse(
        '$_baseUrl/tracks/?client_id=$_clientId&format=json&limit=$limit&search=$query&include=musicinfo&audioformat=mp32');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => JamendoTrack.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search tracks from Jamendo API');
    }
  }
}
