import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'models/song.dart';

class NowPlayingPage extends StatefulWidget {
  final Song song;
  final AudioPlayer audioPlayer;

  const NowPlayingPage({
    Key? key,
    required this.song,
    required this.audioPlayer,
  }) : super(key: key);

  @override
  _NowPlayingPageState createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = true;

  final Color primaryPurple = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final Color lightPurple = Color(0xFFEDE7FF);

  @override
  void initState() {
    super.initState();

    widget.audioPlayer.play(UrlSource(widget.song.audioUrl));

    widget.audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });

    widget.audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F6FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF9D7CF4)),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.song.imageUrl,
                    width: 240,
                    height: 240,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 240,
                      height: 240,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note, size: 60, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.song.title,
                  style: TextStyle(
                    color: darkPurple,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.song.artist,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Slider(
                  value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                  min: 0,
                  max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                  onChanged: (value) async {
                    final newPos = Duration(seconds: value.toInt());
                    await widget.audioPlayer.seek(newPos);
                  },
                  activeColor: primaryPurple,
                  inactiveColor: Colors.grey[300],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatTime(_position), style: TextStyle(color: Colors.grey[600])),
                    Text(_formatTime(_duration), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 40),
                IconButton(
                  iconSize: 70,
                  color: primaryPurple,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await widget.audioPlayer.pause();
                    } else {
                      await widget.audioPlayer.resume();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.audioPlayer.stop();
    super.dispose();
  }
}
