import 'package:flutter/material.dart';
import 'package:tv_show_app/api_services.dart';

class MovieProvider with ChangeNotifier {
  List<dynamic> movies = [];
  List<dynamic> tvShows = [];
  final ApiService apiService = ApiService();
  Future<void> loadMovies() async {
    movies = await apiService.fetchMovies();
    notifyListeners();
  }

  Future<void> loadTVShows() async {
    tvShows = await apiService.fetchTVShows();
    notifyListeners();
  }
}
