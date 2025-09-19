import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyMusicApp());
}

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
              color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.green),
        ),
      ),
      home: const PlaylistScreen(),
    );
  }
}

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  final List<Map<String, String>> _songs = const [
    {
      'title': 'Slipping through my Fingers',
      'asset': 'assets/audio/song1.mp3',
      'image': 'assets/images/song1.jpg'
    },
    {
      'title': 'In my Dreams',
      'asset': 'assets/audio/song2.mp3',
      'image': 'assets/images/song2.jpg'
    },
    {
      'title': 'Through the Years',
      'asset': 'assets/audio/song3.mp3',
      'image': 'assets/images/song3.jpg'
    },
    {
      'title': 'Youre Gonna go Far',
      'asset': 'assets/audio/song4.mp3',
      'image': 'assets/images/song4.jpg'
    },
    {
      'title': 'All Too Well',
      'asset': 'assets/audio/song5.mp3',
      'image': 'assets/images/song5.jpg'
    },
    {
      'title': 'Fix You (ColdPlay)',
      'asset': 'assets/audio/song6.mp3',
      'image': 'assets/images/song6.jpg'
    },
    {
      'title': 'Shout to the Lord',
      'asset': 'assets/audio/song7.mp3',
      'image': 'assets/images/song7.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorite Songs')),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.music_note, color: Colors.blue),
            title: Text(
              _songs[index]['title']!,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.play_arrow, color: Colors.green),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongPlayerScreen(song: _songs[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SongPlayerScreen extends StatefulWidget {
  final Map<String, String> song;

  const SongPlayerScreen({super.key, required this.song});

  @override
  SongPlayerScreenState createState() => SongPlayerScreenState();
}

class SongPlayerScreenState extends State<SongPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadSong();
  }

  Future<void> _loadSong() async {
    try {
      await _audioPlayer.setAsset(widget.song['asset']!);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _stop() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.song['title']!)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: hasError
                ? const Icon(Icons.broken_image, size: 150, color: Colors.red)
                : Image.asset(
                    widget.song['image']!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      setState(() {
                        hasError = true;
                      });
                      return const Icon(Icons.broken_image,
                          size: 150, color: Colors.red);
                    },
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.song['title']!,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.stop, size: 40, color: Colors.red),
                onPressed: _stop,
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40, color: Colors.green),
                onPressed: _playPause,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
