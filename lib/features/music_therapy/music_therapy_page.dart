// music_therapy_page.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'models/song.dart';
import 'service/api_service.dart';
import 'now_playing_page.dart';
import 'search_results_page.dart';

class MusicTherapyPage extends StatefulWidget {
  const MusicTherapyPage({super.key});

  @override
  _MusicTherapyPageState createState() => _MusicTherapyPageState();
}

class _MusicTherapyPageState extends State<MusicTherapyPage> {
  List<Song> songs = [];
  bool isLoading = true;
  AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingIndex;
  PlayerState playerState = PlayerState.stopped;

  final Color primaryColor = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final TextEditingController _searchController = TextEditingController();

  final List<String> calmTitles = [
    'Gentle Breeze',
    'Ocean Waves',
    'Mindful Moments',
    'Deep Calm',
    'Piano Chillax',
    'Meditation',
    'Soothing Sunset',
    'Tranquil Vibes',
    'Peaceful Forest',
    'Zen Flow',
    'Healing Light',
    'Serenity Soundscape',
  ];

  final List<String> calmSubtitles = [
    'Healing Tones',
    'Nature Vibes',
    'Inner Peace',
    'Forest Ambience',
    'Meditative Chants',
    'Soothing Strings',
    'Ambient Bliss',
    'Calm Mind Beats',
    'Breath & Balance',
    'Zen Harmony',
  ];

  @override
  void initState() {
    super.initState();
    loadSongs();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });
  }

  Future<void> loadSongs() async {
    try {
      final fetchedSongs = await ApiService.fetchSongs();
      fetchedSongs.shuffle(); // Optional: randomize

      final limitedSongs = fetchedSongs.take(5).toList();

      for (int i = 0; i < limitedSongs.length; i++) {
        // You must make sure Song class allows this
        limitedSongs[i].title = calmTitles[i % calmTitles.length];
        limitedSongs[i].artist = calmSubtitles[i % calmSubtitles.length];
      }

      setState(() {
        songs = limitedSongs;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading songs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> playSong(String url, int index) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(UrlSource(url));
      setState(() {
        currentlyPlayingIndex = index;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  NowPlayingPage(song: songs[index], audioPlayer: audioPlayer),
        ),
      );
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F6FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF9D7CF4),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Turn stress into harmony',
                    style: TextStyle(
                      color: darkPurple,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey),
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (query) {
                        if (query.trim().isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      SearchResultsPage(keyword: query.trim()),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Trending Music',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View More',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Container(
                            width: 140,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.headphones,
                                    size: 36,
                                    color: Color(0xFF9D7CF4),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Lo-Fi Beats',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Relax & Focus',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 140,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.music_note,
                                  size: 36,
                                  color: Color(0xFF9D7CF4),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Chill Vibes',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Soft & Smooth',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Songs',
                    style: TextStyle(
                      color: darkPurple,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          final imageUrl =
                              song.imageUrl.isNotEmpty
                                  ? song.imageUrl
                                  : 'https://source.unsplash.com/50x50/?relaxing,music,nature,Peace';

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.network(
                                          'https://source.unsplash.com/50x50/?calm,nature,music',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    song.title,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    song.artist,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  trailing: Icon(
                                    currentlyPlayingIndex == index &&
                                            playerState == PlayerState.playing
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    color: primaryColor,
                                  ),
                                  onTap: () {
                                    playSong(song.audioUrl, index);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
