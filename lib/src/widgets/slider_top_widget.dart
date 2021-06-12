import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:provider/provider.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cine_plus/src/providers/moviedb_provider.dart';
import 'package:cine_plus/src/models/movie_now_playing_model.dart';
import 'package:cine_plus/src/style/theme.dart' as Style;
import 'package:cine_plus/src/file/file_storage.dart';

class SliderTop extends StatefulWidget {
  @override
  _SliderTopState createState() => _SliderTopState();
}

class _SliderTopState extends State<SliderTop> {
  PageController pageController = PageController(
    viewportFraction: 1,
    keepPage: true,
  );

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieDBProvider = Provider.of<MovieDBProvider>(context);

    List<MovieNowPlaying> moviesNowPlaying = movieDBProvider.moviesNowPlaying;

    pageController.addListener(() {
      if (pageController.page == moviesNowPlaying.length - 1) {
        print('Cargar Siguientes - Movies Now Playing');

        if (!movieDBProvider.isLoadingPlaying())
          movieDBProvider.loadMoviesNowPlaying();
      }
    });

    if (moviesNowPlaying.length == 0) {
      return Container(
        height: 420.0,
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
      );
    } else {
      return Container(
        height: 420.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: moviesNowPlaying.length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(15.0),
          indicatorColor: Style.MyColors.titleColor,
          indicatorSelectorColor: Style.MyColors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: moviesNowPlaying.length,
            onPageChanged: (index) {
              //_updatePalette(index);
            },
            itemBuilder: (context, index) {
              moviesNowPlaying[index].uniqueID =
                  '${moviesNowPlaying[index].id}-nowPlaying';

              return Hero(
                tag: moviesNowPlaying[index].uniqueID,
                child: GestureDetector(
                  onTap: () {
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PeliculaDetailScreen(
                            pelicula: moviesNowPlaying[index]),
                      ),
                    );
                    */
                  },
                  /*=> Navigator.pushNamed(context, 'detalle',
                      arguments: movies[index]),*/
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 420.0,
                        child: Image(
                          image: NetworkToFileImage(
                            url: moviesNowPlaying[index].getPosterImg(),
                            file: FileStorage.fs.fileFromDocsDir(
                                moviesNowPlaying[index].posterPath),
                            debug: true,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [
                                0.0,
                                0.9
                              ],
                              colors: [
                                Style.MyColors.mainColor.withOpacity(1.0),
                                //moviesNowPlaying[index].colorPalette.color,
                                //colorBackground.color.withOpacity(0.5),
                                //colorBackground.color.withOpacity(1.0),
                                Style.MyColors.mainColor.withOpacity(0.0),
                              ]),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Icon(
                          FontAwesomeIcons.playCircle,
                          color: Style.MyColors.secondColor,
                          size: 40.0,
                        ),
                      ),
                      Positioned(
                        bottom: 30.0,
                        right: 15.0,
                        child: GestureDetector(
                          child: Icon(
                            Icons.favorite,
                            color: moviesNowPlaying[index].favorit
                                ? Colors.red
                                : Colors.white,
                            size: 30.0,
                          ),
                          onTap: () {
                            movieDBProvider
                                .addFavoritMovie(moviesNowPlaying[index].id);
                          },
                        ),
                      ),
                      Positioned(
                          bottom: 30.0,
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: 250.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  moviesNowPlaying[index].title,
                                  style: TextStyle(
                                      height: 1.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    RatingBar.builder(
                                      initialRating:
                                          moviesNowPlaying[index].voteAverage *
                                              5 /
                                              10,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 15.0,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    Text(' '),
                                    Text(
                                      (moviesNowPlaying[index].voteAverage)
                                              .toString() +
                                          '/10 (' +
                                          moviesNowPlaying[index]
                                              .voteCount
                                              .toString() +
                                          ')',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
