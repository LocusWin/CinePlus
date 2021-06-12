import 'dart:convert';
import 'package:cine_plus/src/providers/connection_status_model.dart';
import 'package:cine_plus/src/providers/db_sqfite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cine_plus/src/models/movie_now_playing_model.dart';
import 'package:provider/provider.dart';

class MovieDBProvider with ChangeNotifier {
  String _apikey = '66190a5c6c712f90b5ecf3e34cb45e87';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  bool _isLoadNowPlaying = false;
  bool _isLoadUpcomingMovies = false;
  int _nowPlayingPage = 0;
  int _upcomingMoviesPage = 0;

  List<MovieNowPlaying> _moviesNowPlaying = [];
  List<MovieNowPlaying> _upcomingMovies = [];

  List<MovieNowPlaying> get moviesNowPlaying => this._moviesNowPlaying;
  List<MovieNowPlaying> get upcomingMovies => this._upcomingMovies;

  bool isLoadingPlaying() => this._isLoadNowPlaying;
  bool isLoadingUpcomingMovies() => this._isLoadUpcomingMovies;

  set isLoadNowPlaying(bool value) {
    this._isLoadNowPlaying = value;
  }

  set isLoadUpcomingMovies(bool value) {
    this._isLoadUpcomingMovies = value;
  }

  Future<List<MovieNowPlaying>> _procesarRespuesta(
      Uri url, String tipo, int page) async {
    List<MovieNowPlaying> respuesta;

    if (await ConnectionStatusModel().isOnline) {
      final resp = await http.get(url);

      print("Leyendo del internet " + tipo);

      dynamic decodeData = json.decode(resp.body);

      MoviesNowPlaying respuesta_temp =
          new MoviesNowPlaying.fromJsonList(decodeData['results']);

      if (tipo == 'moviesNowPlaying') {
        for (var i = 0; i < respuesta_temp.items.length; i++) {
          DBProvider.db.addMovieNowPlaying2(respuesta_temp.items[i], page);
        }
      }
      respuesta = respuesta_temp.items;
    } else {
      print("Leyendo local " + tipo);

      if (tipo == 'moviesNowPlaying') {
        respuesta = await DBProvider.db.getMovieNowPlaying(page);
      } else if (tipo == 'upcomingMovies') {
        respuesta = await DBProvider.db.getUpcomingMovies(page);
      }
    }

    /*
    try {
      final resp = await http.get(url);

      print("Leyendo del internet " + tipo);

      dynamic decodeData = json.decode(resp.body);

      MoviesNowPlaying respuesta_temp =
          new MoviesNowPlaying.fromJsonList(decodeData['results']);

      for (var i = 0; i < respuesta_temp.items.length; i++) {
        DBProvider.db.addMovieNowPlaying2(respuesta_temp.items[i]);
      }

      respuesta = respuesta_temp.items;
    } catch (e) {
      print("Leyendo local " + tipo);

      respuesta = await DBProvider.db.getAllMovieNowPlaying();
    }
    */

    return respuesta;
  }

/*
  Future<List<MovieNowPlaying>> _procesarRespuesta(Uri url, String tipo) async {
    List<MovieNowPlaying> respuesta;

    print("Leyendo local " + tipo);

    respuesta = await DBProvider.db.getAllMovieNowPlaying();

    return respuesta;
  }*/

  loadMoviesNowPlaying() async {
    if (_isLoadNowPlaying) return [];
    _isLoadNowPlaying = true;
    _nowPlayingPage++;

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
      'page': _nowPlayingPage.toString(),
    });

    print('Cargando Now Playing - pagina: ' + _nowPlayingPage.toString());

    final resp =
        await _procesarRespuesta(url, "moviesNowPlaying", _nowPlayingPage);

    resp.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

    _moviesNowPlaying.addAll(resp);

    notifyListeners();

    print('NotifyListeners MoviesNowPlaying');

    _isLoadNowPlaying = false;
  }

  loadUpcomingMovies() async {
    if (_isLoadUpcomingMovies) return [];
    _isLoadUpcomingMovies = true;
    _upcomingMoviesPage++;

    final url = Uri.https(_url, '3/movie/upcoming', {
      'api_key': _apikey,
      'language': _language,
      'region': 'US',
      'page': _upcomingMoviesPage.toString(),
    });

    print(
        'Cargando Upcoming Movies - pagina: ' + _upcomingMoviesPage.toString());

    final resp =
        await _procesarRespuesta(url, "upcomingMovies", _upcomingMoviesPage);

    if (resp.isEmpty) {
      _upcomingMoviesPage--;
      _isLoadUpcomingMovies = false;
      return resp;
    }

    _upcomingMovies.addAll(resp);

    notifyListeners();

    print('NotifyListeners UpcomingMovies');

    _isLoadUpcomingMovies = false;
  }

  addFavoritMovie(int id) {
    modifyFavorit(this._moviesNowPlaying, id);
    modifyFavorit(this._upcomingMovies, id);

    notifyListeners();

    print('NotifyListeners Favorit');
  }

  void modifyFavorit(List<MovieNowPlaying> list, int id) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        if (list[i].favorit == true) {
          list[i].favorit = false;
        } else {
          list[i].favorit = true;
        }
      }
    }
  }
}
