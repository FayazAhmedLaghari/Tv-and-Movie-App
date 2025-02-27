import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerScreen extends StatefulWidget {
  final String trailerKey;

  const TrailerScreen({Key? key, required this.trailerKey}) : super(key: key);

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = true;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerKey,
      flags: YoutubePlayerFlags(
        autoPlay: false, // Set to false initially
        mute: false,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (mounted && _controller.value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
      _controller.play(); // Start playing when ready
    }
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Watch Trailer")),
      body: Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: false,
            onReady: () {
              setState(() {
                _isPlayerReady = true;
              });
              _controller.play(); // Start playing when ready
            },
          ),
          builder: (context, player) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isPlayerReady
                    ? player
                    : CircularProgressIndicator(), // Show loading until ready
              ],
            );
          },
        ),
      ),
    );
  }
}
