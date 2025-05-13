import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/song.dart';

class ApiService {
  // Fetch meditation, calm, and relaxing songs from Deezer API
  static Future<List<Song>> fetchSongs() async {
    // Define the search query for meditation, calm, and relaxing songs
    final String query = 'meditation yoga sleep calm relaxation Water Peace';
    final response = await http.get(
      Uri.parse('https://api.deezer.com/search?q=$query'),
    );

    // Check if the response status is OK
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> tracks = data['data']; // Extract the tracks data

      // Convert the JSON response to Song objects and return them as a list
      return tracks.map((track) => Song.fromJson(track)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }
}
