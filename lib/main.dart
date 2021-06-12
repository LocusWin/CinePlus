import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cine_plus/main_screen.dart';
import 'package:cine_plus/src/file/file_storage.dart';
import 'package:cine_plus/src/pages/actors_page.dart';
import 'package:cine_plus/src/pages/favorits_page.dart';
import 'package:cine_plus/src/pages/movies_page.dart';
import 'package:cine_plus/src/pages/series_page.dart';
import 'package:cine_plus/src/providers/connection_status_model.dart';
import 'package:cine_plus/src/providers/moviedb_provider.dart';
import 'package:flutter/material.dart';
import 'package:cine_plus/src/style/theme.dart' as style;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FileStorage.fs.appDocsDir;

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new MovieDBProvider()),
        ChangeNotifierProvider(create: (_) => new ConnectionStatusModel()),
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
      title: 'Cine - Plus',
      color: style.MyColors.mainColor,
      theme: ThemeData(scaffoldBackgroundColor: style.MyColors.mainColor),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => AnimatedSplashScreen(
              splash: 'assets/img/splash_screen_ok.png',
              backgroundColor: style.MyColors.mainColor,

              //splashIconSize: 800.0,
              nextScreen: MainScreen(),
              //nextScreen: MainScreenDiyNav(),
              splashTransition: SplashTransition.fadeTransition,
              duration: 3000,
            ),
        'main_screen': (BuildContext context) => MainScreen(),
        'movie_page': (BuildContext context) => MoviesPage(),
        'series_page': (BuildContext context) => SeriesPage(),
        'actor_page': (BuildContext context) => ActorsPage(),
        'favorits_page': (BuildContext context) => FavoritsPage(),
      },
    );
  }
}
