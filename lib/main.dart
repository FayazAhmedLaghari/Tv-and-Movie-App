import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movie_provider.dart';
import 'home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MovieProvider()
              ..loadMovies()
              ..loadTVShows()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
