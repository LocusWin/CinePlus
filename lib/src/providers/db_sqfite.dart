import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:cine_plus/src/models/movie_now_playing_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  //Constructor Privado
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getExternalStorageDirectory();
    final path = join(documentsDirectory.path, 'cinePlus.db');

    //TODO: Falta por poner List<int> genreIds; y OriginalLanguage originalLanguage;
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE MovieNowPlaying('
            'id INTEGER PRIMARY KEY,'
            'movie_id INTEGER,'
            'adult INTEGER,'
            'backdrop_path TEXT,'
            'original_title TEXT,'
            'overview TEXT,'
            'popularity NUMERIC,'
            'poster_path TEXT,'
            'release_date TEXT,'
            'title TEXT,'
            'video INTEGER,'
            'vote_average NUMERIC,'
            'vote_count INTEGER,'
            'page INTEGER'
            ')');
      },
    );
  }

  addMovieNowPlaying2(MovieNowPlaying movieNowPlaying, int page) async {
    final db = await database;

    final original_title = movieNowPlaying.originalTitle.replaceAll("'", " ");
    final title = movieNowPlaying.title.replaceAll("'", " ");
    final overview = movieNowPlaying.overview.replaceAll("'", " ");

    print('Page insert: ' + page.toString());
    print('Titulo: $title');

    final res = await db.rawInsert(
        "INSERT Into MovieNowPlaying (movie_id, adult, backdrop_path, original_title, overview, popularity, poster_path, release_date, title, video, vote_average, vote_count, page) "
        "VALUES(${movieNowPlaying.id}, '${movieNowPlaying.adult}', '${movieNowPlaying.backdropPath}', '${original_title}', '${overview}', '${movieNowPlaying.popularity}', '${movieNowPlaying.posterPath}', '${movieNowPlaying.releaseDate}', '${title}', '${movieNowPlaying.video}', '${movieNowPlaying.voteAverage}', '${movieNowPlaying.voteCount}', '${page}')");

    return res;
  }

  addMovieNowPlaying(MovieNowPlaying movieNowPlaying) async {
    final db = await database;
    final res = await db.insert('MovieNowPlaying', movieNowPlaying.toJson());
    return res;
  }

/*
  getAllMovieNowPlaying() async {
    final db = await database;
    final res = await db.query('MovieNowPlaying');
    
    List<MovieNowPlaying> list = res.isNotEmpty
        ? res.map((c) => MovieNowPlaying.fromJson(c)).toList()
        : [];

    return list;
  }
  */

  getMovieNowPlaying(int page) async {
    final db = await database;

    final res =
        await db.query('MovieNowPlaying', where: 'page = ?', whereArgs: [page]);

    List<MovieNowPlaying> list = res.isNotEmpty
        ? res.map((c) => MovieNowPlaying.fromJson(c)).toList()
        : [];

    return list;
  }

  getUpcomingMovies(int page) async {
    List<MovieNowPlaying> list = [];
    return list;
  }
}
