import 'package:cine_plus/src/models/movie_now_playing_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cine_plus/src/providers/moviedb_provider.dart';
import 'package:cine_plus/src/style/theme.dart' as Style;

class UpcomingMovies extends StatefulWidget {
  UpcomingMovies({Key key}) : super(key: key);

  @override
  _UpcomingMoviesState createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends State<UpcomingMovies> {
  final pageController = new PageController(
    initialPage: 1,
    keepPage: true,
    viewportFraction: 0.1,
  );

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieDBProvider = Provider.of<MovieDBProvider>(context);
    List<MovieNowPlaying> upcomingMovies = movieDBProvider.upcomingMovies;

    pageController.addListener(() {
      if (pageController.page == upcomingMovies.length - 1) {
        print('Cargar Siguientes - Upcoming Movies');

        if (!movieDBProvider.isLoadingUpcomingMovies())
          movieDBProvider.loadUpcomingMovies();
      }
    });

    return Container(
      width: double.infinity,
      height: 260.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "PRÓXIMOS ESTRENOS",
              style: TextStyle(
                  color: Style.MyColors.titleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0),
            ),
          ),
          SizedBox(
            height: 3.0,
          ),
          (upcomingMovies.length == 0)
              ? Container(
                  height: 240.0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      )
                    ],
                  ),
                )
              : Container(
                  height: 240.0,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 36.0),
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    itemCount: upcomingMovies.length,
                    itemBuilder: (context, index) {
                      upcomingMovies[index].uniqueID =
                          '${upcomingMovies[index].id}-movieHorizontal';

                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, top: 5.0, right: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            /*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PeliculaDetailScreen(pelicula: peliculas[index]),
                  ),
                );
                */
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: [
                                  upcomingMovies[index].posterPath == null
                                      ? Hero(
                                          tag: upcomingMovies[index].uniqueID,
                                          child: Container(
                                            width: 120.0,
                                            height: 180.0,
                                            decoration: new BoxDecoration(
                                              //color: Style.MyColors.secondColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  EvaIcons.filmOutline,
                                                  color: Colors.white,
                                                  size: 60.0,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Hero(
                                          tag: upcomingMovies[index].id,
                                          child: Container(
                                            width: 120.0,
                                            height: 180.0,
                                            child: Image(
                                              image: NetworkImage(
                                                  upcomingMovies[index]
                                                      .getPosterImg()),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 2.0,
                                    right: 2.0,
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.favorite,
                                        color: upcomingMovies[index].favorit
                                            ? Colors.red
                                            : Colors.white,
                                        size: 20.0,
                                      ),
                                      onTap: () {
                                        movieDBProvider.addFavoritMovie(
                                            upcomingMovies[index].id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: 120,
                                child: Text(
                                  upcomingMovies[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  //maxLines: 2,
                                  style: TextStyle(
                                      height: 1.4,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 11.0),
                                ),
                              ),
                              Container(
                                width: 120,
                                child: Text(
                                  upcomingMovies[index].releaseDate,
                                  overflow: TextOverflow.ellipsis,
                                  //maxLines: 2,
                                  style: TextStyle(
                                      height: 1.4,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 11.0),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
