import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MovieTVApp());
}

class MovieTVApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie & TV Show App',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = 'YOUR_TMDB_API_KEY';
  List movies = [];
  List tvShows = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchTVShows();
  }

  Future<void> fetchMovies() async {
    var response = await Dio().get(
        'https://api.themoviedb.org/3/trending/movie/week',
        queryParameters: {'api_key': apiKey});
    setState(() {
      movies = response.data['results'];
    });
  }

  Future<void> fetchTVShows() async {
    var response = await Dio().get(
        'https://api.themoviedb.org/3/trending/tv/week',
        queryParameters: {'api_key': apiKey});
    setState(() {
      tvShows = response.data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IMDb Clone')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Section(title: 'Trending Movies', items: movies),
            Section(title: 'Trending TV Shows', items: tvShows),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List items;

  Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(item: item)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            'https://image.tmdb.org/t/p/w500${item['poster_path']}',
                            height: 150),
                      ),
                      SizedBox(height: 5),
                      Text(item['title'] ?? item['name'],
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final Map item;
  DetailsScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title'] ?? item['name'])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                    'https://image.tmdb.org/t/p/w500${item['poster_path']}'),
              ),
            ),
            SizedBox(height: 20),
            Text(item['overview'], style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
