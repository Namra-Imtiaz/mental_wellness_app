// search_results_page.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../models/song.dart';
import '../../../services/api_service.dart';
import 'now_playing_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String keyword;

  const SearchResultsPage({super.key, required this.keyword});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Song> results = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchSongs(widget.keyword);
  }

  Future<void> _searchSongs(String keyword) async {
    try {
      final fetched = await ApiService.fetchSongs();
      setState(() {
        results = fetched.where((song) =>
          song.title.toLowerCase().contains(keyword.toLowerCase()) ||
          song.artist.toLowerCase().contains(keyword.toLowerCase())
        ).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Search failed: \$e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF9D7CF4),
      appBar: AppBar(
        backgroundColor:  Color(0xFF9D7CF4),
        elevation: 0,
        title: Text('Results for "${widget.keyword}"', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Color(0xFF9D7CF4)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : results.isEmpty
              ? Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final song = results[index];
                    return ListTile(
                      leading: Image.network(song.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NowPlayingPage(
                              song: song,
                              audioPlayer: AudioPlayer(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
