import 'package:dio/dio.dart';

class ApiService {
  final String apiKey = '5eed4c4852832d4abb8f0ee53644852e';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final Dio dio = Dio();
  Future<List<dynamic>> fetchMovies() async {
    final response = await dio.get('$baseUrl/movie/popular?api_key=$apiKey');
    return response.data['results'];
  }

  Future<List<dynamic>> fetchTVShows() async {
    final response = await dio.get('$baseUrl/tv/popular?api_key=$apiKey');
    return response.data['results'];
  }

  Future<String?> fetchTrailer(int movieId) async {
    final response =
        await dio.get('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    List videos = response.data['results'];
    if (videos.isNotEmpty) {
      return videos.firstWhere(
          (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
          orElse: () => null)?['key'];
    }
    return null;
  }
}
