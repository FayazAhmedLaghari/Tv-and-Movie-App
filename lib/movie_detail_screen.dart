import 'package:flutter/material.dart';
import 'package:tv_show_app/api_services.dart'; // Ensure this is the correct import
import 'package:tv_show_app/trailer_screen.dart'; // Import trailer screen

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final ApiService apiService = ApiService();
  String? trailerKey;

  @override
  void initState() {
    super.initState();
    fetchTrailer();
  }

  Future<void> fetchTrailer() async {
    int movieId = widget.movie['id'];
    String? key = await apiService.fetchTrailer(movieId);
    setState(() {
      trailerKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.movie['title'] ?? widget.movie['name'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.movie['title'] ?? widget.movie['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.movie['overview'] ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: trailerKey != null
                    ? () async {
                        // Show loading indicator before navigation
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              Center(child: CircularProgressIndicator()),
                        );

                        await Future.delayed(
                            Duration(seconds: 2)); // Simulate loading time

                        Navigator.pop(context); // Close loading dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TrailerScreen(trailerKey: trailerKey!),
                          ),
                        );
                      }
                    : null, // Disable button if no trailer
                child: Text(trailerKey != null
                    ? '▶ Watch Trailer'
                    : 'No Trailer Available'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
