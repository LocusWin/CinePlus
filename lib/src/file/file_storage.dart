import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileStorage {
  static String _dir;
  static Directory _appDocsDir;
  static final FileStorage fs = FileStorage._();

  FileStorage._();

  Future<Directory> get appDocsDir async {
    if (_appDocsDir != null) return _appDocsDir;

    _appDocsDir = await getExternalStorageDirectory();

    _dir = (await getExternalStorageDirectory()).path;

    createFolder(_dir);

    return _appDocsDir;
  }

  void createFolder(String directory) async {
    if (await Directory(directory + "/poster").exists() != true) {
      print("Directory not exist - Creating");
      new Directory(directory + "/poster").createSync(recursive: true);
    } else {
      print("Directory exist");
    }
  }

  File fileFromDocsDir(String filename) {
    String f = filename;
    if (filename.contains('/')) {
      f = filename.replaceFirst('/', '');
    }

    String pathName = p.join(_appDocsDir.path, f);
    return File(pathName);
  }
}
