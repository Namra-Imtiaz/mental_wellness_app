class Song {
  String title;
  String artist;
  final String imageUrl;
  final String audioUrl;

  Song({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'], // Title of the song
      artist:
          json['artist']['name'], // Artist's name, assuming it's under 'artist' object
      imageUrl:
          json['album']['cover_big'], // Image URL (album cover), assuming it's under 'album'
      audioUrl:
          json['preview'], // Preview URL (30-second audio), assuming it's under 'preview'
    );
  }
}
