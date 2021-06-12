import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cine_plus/src/models/movie_now_playing_model.dart';
import 'package:cine_plus/src/providers/moviedb_provider.dart';
import 'package:cine_plus/src/widgets/slider_top_widget.dart';
import 'package:cine_plus/src/widgets/upcoming_movies.dart';
import 'package:cine_plus/src/style/theme.dart' as Style;

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieDBProvider =
        Provider.of<MovieDBProvider>(context, listen: false);
    movieDBProvider.loadMoviesNowPlaying();
    movieDBProvider.loadUpcomingMovies();

    return Scaffold(
        body: ListView(
      cacheExtent: 1024,
      children: [
        SliderTop(),
        UpcomingMovies(),
      ],
    ));
  }
}
