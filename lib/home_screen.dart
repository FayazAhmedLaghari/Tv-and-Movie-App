import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'movie_provider.dart';
import 'movie_detail_screen.dart'; // Import the detail screen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Movie & TV Show App')),
      body: ListView(
        children: [
          _buildSection('Popular Movies', movieProvider.movies,
              movieProvider.movies.isEmpty),
          _buildSection('Popular TV Shows', movieProvider.tvShows,
              movieProvider.tvShows.isEmpty),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> items, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200,
          child: isLoading
              ? _buildShimmerEffect()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildItem(items[index], context);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildItem(dynamic item, BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: item),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w200${item['poster_path']}',
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 5),
            Text(
              item['title'] ?? item['name'],
              style: TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 100, height: 150, color: Colors.white),
              ),
              SizedBox(height: 5),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 80, height: 12, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
