import 'package:cine_plus/src/providers/connection_status_model.dart';
import 'package:cine_plus/src/providers/moviedb_provider.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:cine_plus/src/pages/movies_page.dart';
import 'package:cine_plus/src/pages/series_page.dart';
import 'package:cine_plus/src/pages/actors_page.dart';
import 'package:cine_plus/src/pages/favorits_page.dart';
import 'package:cine_plus/src/style/theme.dart' as style;
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final screen = [
    MoviesPage(),
    SeriesPage(),
    ActorsPage(),
    FavoritsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('CINE+'),
        backgroundColor: style.MyColors.mainColor,
        actions: <Widget>[
          Consumer<ConnectionStatusModel>(
            builder: (_, model, __) {
              return model.isOnline
                  ? Icon(Icons.signal_wifi_4_bar)
                  : Icon(Icons.signal_wifi_off_outlined);
            },
          ),
          IconButton(
            icon: const Icon(EvaIcons.searchOutline, color: Colors.white),
            onPressed: () {
              /*
              showSearch(
                context: context,
                delegate: DataSearch(),
               
                //query: 'Hola',
              ); 
              */
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screen,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.movie),
          Icon(Icons.tv),
          Icon(Icons.person),
          Icon(Icons.favorite),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        animationCurve: Curves.easeOutSine,
        animationDuration: const Duration(milliseconds: 250),
        backgroundColor: Colors.transparent,
        //color: Style.MyColors.mainColor,
        height: 50.0,
      ),
    );
  }
}
